my_solver="GUROBI"

def arranging(n,k,print):

	p = MixedIntegerLinearProgram(maximization=True,solver=my_solver)

	G=graphs.CompleteGraph(n+1)
	for e in G.edges():
		if e[1]-e[0] > k:
			G.delete_edge(e)
	
#	variável da aresta: x[e]=1 implica que e está no nosso caminho
	x = p.new_variable(binary=True)

#	equações dos vértices
	for u in G.vertices():
		equation=0
		for e in G.edges_incident(u):
			equation+=x[e]
		if u==0:
			p.add_constraint(equation==1)
		else:
			p.add_constraint(equation<=2)
	
	for i in range(1,k+1):
		equation=0
		for e in G.edges():
			if e[1]-e[0] == i:
				equation+=x[e]
		if i>=2*k-n+1:
			p.add_constraint(equation==2)
		else:
			p.add_constraint(equation==1)

	objective=0
	for e in G.edges():
		objective+=x[e]
		
	p.set_objective(objective)

	p.solve()
	solution=p.get_values(x).items()
	R=[]
	for s in solution:
		if s[1]==1:
			R.append(s[0])
	H=Graph(R)

	while H.is_tree()==False:
		comps=H.connected_components()
		for comp in comps:
			X=H.subgraph(comp)
			if X.size() > X.order()-1:
				equation=0
				for e in X.edges():
					equation+=x[e]
				p.add_constraint(equation<=X.order()-1)
		p.solve()
		solution=p.get_values(x).items()
		R=[]
		for s in solution:
			if s[1]==1:
				R.append(s[0])
		H=Graph(R)

	if print:	
		H.show(layout="circular")
	
	lista=[0]
	u=0
	while H.order()>=2:
		v=H.neighbors(u)[0]
		H.delete_vertex(u)
		lista.append(v)
		u=v
	return lista
	
def arranging_with_restrictions(n,k,restrictions):

	p = MixedIntegerLinearProgram(maximization=True,solver=my_solver)

	G=graphs.CompleteGraph(n+1)
	for e in G.edges():
		if e[1]-e[0] > k:
			G.delete_edge(e)
	
#	variável da aresta: x[e]=1 implica que e está no nosso caminho
	x = p.new_variable(binary=True)

#	equações dos vértices
	for u in G.vertices():
		equation=0
		for e in G.edges_incident(u):
			equation+=x[e]
		if u==0:
			p.add_constraint(equation==1)
		else:
			p.add_constraint(equation<=2)
	
	for i in range(1,k+1):
		equation=0
		for e in G.edges():
			if e[1]-e[0] == i:
				equation+=x[e]
		if i>=2*k-n+1:
			p.add_constraint(equation==2)
		else:
			p.add_constraint(equation==1)
			
#	adding restrictions
#	for restriction in restrictions:
#		u,v=restriction
#		if u < v:
#			e=(u,v,None)
#		else:
#			e=(v,u,None)
#		print(e)
#		p.add_constraint(x[e]==1)
	X=Graph(restrictions)
	for e in G.edges():
		if X.has_edge(e):
			p.add_constraint(x[e]==1)

	objective=0
	for e in G.edges():
		objective+=x[e]
		
	p.set_objective(objective)

	p.solve()
	solution=p.get_values(x).items()
	R=[]
	for s in solution:
		if s[1]==1:
			R.append(s[0])
	H=Graph(R)

	while H.is_tree()==False:
		comps=H.connected_components()
		for comp in comps:
			X=H.subgraph(comp)
			if X.size() > X.order()-1:
				equation=0
				for e in X.edges():
					equation+=x[e]
				p.add_constraint(equation<=X.order()-1)
		p.solve()
		solution=p.get_values(x).items()
		R=[]
		for s in solution:
			if s[1]==1:
				R.append(s[0])
		H=Graph(R)
	
	lista=[0]
	u=0
	while H.order()>=2:
		v=H.neighbors(u)[0]
		H.delete_vertex(u)
		lista.append(v)
		u=v
	return lista
	
def arranging_with_restrictions_spec_finishing(n,k,restrictions,uu):

	p = MixedIntegerLinearProgram(maximization=True,solver=my_solver)

	G=graphs.CompleteGraph(n+1)
	for e in G.edges():
		if e[1]-e[0] > k:
			G.delete_edge(e)
	
#	variável da aresta: x[e]=1 implica que e está no nosso caminho
	x = p.new_variable(binary=True)

#	equações dos vértices
	for u in G.vertices():
		equation=0
		for e in G.edges_incident(u):
			equation+=x[e]
		if u==0 or u==uu:
			p.add_constraint(equation==1)
		else:
			p.add_constraint(equation<=2)
	
	for i in range(1,k+1):
		equation=0
		for e in G.edges():
			if e[1]-e[0] == i:
				equation+=x[e]
		if i>=2*k-n+1:
			p.add_constraint(equation==2)
		else:
			p.add_constraint(equation==1)
			
#	adding restrictions
#	for restriction in restrictions:
#		u,v=restriction
#		if u < v:
#			e=(u,v,None)
#		else:
#			e=(v,u,None)
#		print(e)
#		p.add_constraint(x[e]==1)
	X=Graph(restrictions)
	for e in G.edges():
		if X.has_edge(e):
			p.add_constraint(x[e]==1)

	objective=0
	for e in G.edges():
		objective+=x[e]
		
	p.set_objective(objective)

	p.solve()
	solution=p.get_values(x).items()
	R=[]
	for s in solution:
		if s[1]==1:
			R.append(s[0])
	H=Graph(R)

	while H.is_tree()==False:
		comps=H.connected_components()
		for comp in comps:
			X=H.subgraph(comp)
			if X.size() > X.order()-1:
				equation=0
				for e in X.edges():
					equation+=x[e]
				p.add_constraint(equation<=X.order()-1)
		p.solve()
		solution=p.get_values(x).items()
		R=[]
		for s in solution:
			if s[1]==1:
				R.append(s[0])
		H=Graph(R)
	
	lista=[0]
	u=0
	while H.order()>=2:
		v=H.neighbors(u)[0]
		H.delete_vertex(u)
		lista.append(v)
		u=v
	return lista
	
def symmetric_edge(G,e):
	n=G.order()
	u,v,l=e
	new_u=n-u-1
	new_v=n-v-1
	return (new_v,new_u,None)
	
#def symmetric_edge(G,e,axis):
#	n=G.order()
#	u,v,l=e
#	new_u=n-u-1
#	new_v=n-v-1
#	return (new_v,new_u,None)
	
def arranging_symmetric(n,print,restrictions):

	k=(n+1)/2

	p = MixedIntegerLinearProgram(maximization=True,solver=my_solver)

	G=graphs.CompleteGraph(n+1)
	for e in G.edges():
		if e[1]-e[0] > k:
			G.delete_edge(e)
	
#	variável da aresta: x[e]=1 implica que e está no nosso caminho
	x = p.new_variable(binary=True)

#	equações dos vértices
	for u in G.vertices():
		equation=0
		for e in G.edges_incident(u):
			equation+=x[e]
		if u==0:
			p.add_constraint(equation==1)
		else:
			p.add_constraint(equation<=2)
	
	for i in range(1,k+1):
		equation=0
		for e in G.edges():
			if e[1]-e[0] == i:
				equation+=x[e]
		if i>=2*k-n+1:
			p.add_constraint(equation==2)
		else:
			p.add_constraint(equation==1)
			
	for e in G.edges():
		f=symmetric_edge(G,e)
		p.add_constraint(x[e]==x[f])
		
	X=Graph(restrictions)
	for e in G.edges():
		if X.has_edge(e):
			p.add_constraint(x[e]==1)

	objective=0
	for e in G.edges():
		objective+=x[e]
		
	p.set_objective(objective)

	p.solve()
	solution=p.get_values(x).items()
	R=[]
	for s in solution:
		if s[1]==1:
			R.append(s[0])
	H=Graph(R)

	if print:	
		for e in H.edges():
			G.set_edge_label(e[0],e[1],1)
		G.show(color_by_label=True)

	while H.is_tree()==False:
		comps=H.connected_components()
		for comp in comps:
			X=H.subgraph(comp)
			if X.size() > X.order()-1:
				equation=0
				for e in X.edges():
					equation+=x[e]
				p.add_constraint(equation<=X.order()-1)
		p.solve()
		solution=p.get_values(x).items()
		R=[]
		for s in solution:
			if s[1]==1:
				R.append(s[0])
		H=Graph(R)
	
	lista=[0]
	u=0
	while H.order()>=2:
		v=H.neighbors(u)[0]
		H.delete_vertex(u)
		lista.append(v)
		u=v
	return lista
	
def differences(sol):
	result=[]
	for i in range(len(sol)-1):
		diff=sol[i]-sol[i+1]
		result.append(abs(diff))
	return result
	
def test_solution_vertices(sol,k):
	diffs=differences(sol)
	n=max(sol)
	for i in range(1,k+1):
		if i>=2*k-n+1:
			if diffs.count(i)!=2:
				return False
		else:
			if diffs.count(i)!=1:
				return False
	return True
	
def is_path(G):
	if G.is_tree()==False:
		return False
	if max(G.degree())>2:
		return False
	if min(G.degree())>1:
		return False
	return True
	
def test_solution_edges(edges,k):
	P=Graph(edges)
	if is_path(P)==False:
		print("a solução não induz um caminho")
		return False
	diffs=[]
	n=0
	for e in edges:
		u,v=e
		diffs.append(abs(v-u))
		if v>n:
			n=v
		if u>n:
			n=u
	for i in range(1,k+1):
		result=True
		if i>=2*k-n+1:
			if diffs.count(i)!=2:
				print("aresta do tipo "+str(i)+" não aparece exatamente duas vezes")
				result=False
		else:
			if diffs.count(i)!=1:
				print("aresta do tipo "+str(i)+" não aparece exatamente uma vez")
				result=False
	return result
	
def canonical_k_max(n):
	result=[(0,n-1),(1,n),(1,n-1),(3,n),(2,n-3)]
	
#	odd edges
	u,v=(2,n-2)
	while v>u:
		result.append((u,v))
		u+=1
		v-=1
	u,v=(5,n-2)
	while v>u:
		result.append((u,v))
		u+=2
		v-=2
	u,v=(4,n-5)
	while v>u:
		result.append((u,v))
		u+=2
		v-=2
		
# A solução acima resolve sempre que n não é múltiplo de 4.
# Para corrigí-la incluímos a parte abaixo
	if (n%4)==0:
		c=n/2
		a=c-2
		b=c-1
		d=c+1
		e=c+2
		result.remove((a,d))
		result.remove((d,e))
		result.remove((b,d))
#aparentemente temos duas soluções para este problema:
#		result.append((c,d))
#		result.append((a,c))
#		result.append((b,e))
		result.append((a,d))
		result.append((c,e))
		result.append((b,c))

	return result
	
def interesting_parallel_edges(n):
	result=[]
	u,v=(1,n-1)
	while v>u:
		result.append((u,v))
		u+=1
		v-=1
	return result
	
def secondary_parallel_edges(n):
	result=[]
	u,v=(4,n-1)
	while v>u:
		result.append((u,v))
		u+=1
		v-=1
	return result
	
def show_solution_edges(S):
	G=Graph(S)
	G.show(layout="circular",color_by_label=True)

def show_solution_vertices(S):
	G=Graph()
	G.add_path(S)
	G.show(layout="circular",color_by_label=True)
	

def arranging_maximizing_simmilarity(n,k,pre_solution):

	p = MixedIntegerLinearProgram(maximization=True,solver=my_solver)

	G=graphs.CompleteGraph(n+1)
	for e in G.edges():
		if e[1]-e[0] > k:
			G.delete_edge(e)
	
#	variável da aresta: x[e]=1 implica que e está no nosso caminho
	x = p.new_variable(binary=True)

#	equações dos vértices
	for u in G.vertices():
		equation=0
		for e in G.edges_incident(u):
			equation+=x[(e[0],e[1])]
		if u==0:
			p.add_constraint(equation==1)
		else:
			p.add_constraint(equation<=2)
	
	for i in range(1,k+1):
		equation=0
		for e in G.edges():
			if e[1]-e[0] == i:
				equation+=x[(e[0],e[1])]
		if i>=2*k-n+1:
			p.add_constraint(equation==2)
		else:
			p.add_constraint(equation==1)

#	a solução deve ser um conjunto de arestas
	objective=0
	for e in pre_solution:
		if e[1]-e[0] <= k:
			objective+=x[e]
#	p.add_constraint(objective==n-3)
		
	p.set_objective(objective)

#	conjunto brutal de restrições
	for S in Combinations(G.vertices()):
		if len(S)>=3:
			H=G.subgraph(S)
			if H.size()>=3:
				equation=0
				for e in H.edges():
					equation+=x[(e[0],e[1])]
				p.add_constraint(equation<=H.order()-1)

	print(p.solve())
	solution=p.get_values(x).items()
	R=[]
	simmilarity=[]
	for s in solution:
		if s[1]==1:
			R.append(s[0])
			if s[0] in pre_solution:
				simmilarity.append(s[0])
	print("solution: "+ str(R))
	print("simmilarity: "+str(simmilarity))
	H=Graph(R)
	for e in simmilarity:
		H.set_edge_label(e[0],e[1],1)
	H.show(layout="circular",color_by_label=True)		
#	while H.is_tree()==False:
#		print("gerador de restrições")
#		comps=H.connected_components()
#		for comp in comps:
#			X=H.subgraph(comp)
#			if X.size() > X.order()-1:
#				equation=0
#				for e in X.edges():
#					equation+=x[e]
#				p.add_constraint(equation<=X.order()-1)
##		equation=0
##		for e in R:
##			equation+=x[e]
##		p.add_constraint(equation<=n-2)
#		p.solve()
#		solution=p.get_values(x).items()
#		R=[]
#		for s in solution:
#			if s[1]==1:
#				R.append(s[0])
#		H=Graph(R)
	
	lista=[0]
	u=0
	while H.order()>=2:
		v=H.neighbors(u)[0]
		H.delete_vertex(u)
		lista.append(v)
		u=v
	return lista
	
def what_was_replaced(S1,S2):
	removed=[]
	added=[]
	for e in S1:
		if (e in S2)==False:
			removed.append(e)
	print("removed: " + str(removed))
	for e in S2:
		if (e in S1)==False:
			added.append(e)
	print("added: " + str(added))
	
def edges_to_pairs(edges):
	result=[]
	for e in edges:
		x,y,z=e
		result.append((x,y))
	return result
	
def edges_in_pairs(G):
	return edges_to_pairs(G.edges())
	
def sequence_to_pairs(S):
	P=Graph()
	P.add_path(S)
	return edges_in_pairs(P)
	
def symmetric_difference(S1,S2):
	S=copy(S1)
	for e in S2:
		if e in S1:
			S.remove(e)
		else:
			S.append(e)
	return S
	
def parallels(n,e,k):
	result=[]
	u,v=e
	while v>u and u<=n and v>=0:
		if v-u<=k:
			result.append((u,v))
		u+=1
		v-=1
	u,v=e
	u-=1
	v+=1
	while u>=0 and v<=n:
		if v-u<=k:
			result.append((u,v))
		u-=1
		v+=1
	return result
	
def parallels_k_min(n):
	k=ceil(n/2)
	result=parallels(n,(0,k),k)
	result+=parallels(n,(k+1,n),k)
	
	return result
	
def cycle_position(u,n):
	angle=u*2*pi/(n+1)
	return (cos(angle),sin(angle))

def director_vector(e,n):
	u,v,l=e
	ux,uy=cycle_position(u,n)
	vx,vy=cycle_position(v,n)
	return (vx-ux,vy-uy)
	
#def are_parallel(e1,e2,n):
#	u,v,l=e1
#	x,y,l=e2
#	if u<x:	
#		new_u=n
#		new_v=v+u+1
#	else:
#		new_u=n
#		new_v=y+x+1
##	print(e1_sym)
#	if 	u-x==y-v or new_v-x==y-new_u:
#		return True
#	return False
	
def are_parallel(e1,e2,n):
	x1,y1=director_vector(e1,n)
	x2,y2=director_vector(e2,n)
	if 0 in [x1,x2]:
		if x1==x2:
			return True
		return False
	if 0 in [y1,y2]:
		if y1==y2:
			return True
		else:
			return False	
	if x1/x2 == y1/y2:
		return True
	return False
	
def arranging_maximizing_parallels(n,k,should_print):

	p = MixedIntegerLinearProgram(maximization=True,solver=my_solver)

	G=graphs.CompleteGraph(n+1)
	for e in G.edges():
		if e[1]-e[0] > k:
			G.delete_edge(e)
	
#	variável da aresta: x[e]=1 implica que e está no nosso caminho
	x = p.new_variable(binary=True)

#	equações dos vértices
	for u in G.vertices():
		equation=0
		for e in G.edges_incident(u):
			equation+=x[e]
		if u==0:
			p.add_constraint(equation==1)
		else:
			p.add_constraint(equation<=2)
	
	for i in range(1,k+1):
		equation=0
		for e in G.edges():
			if e[1]-e[0] == i:
				equation+=x[e]
		if i>=2*k-n+1:
			p.add_constraint(equation==2)
		else:
			p.add_constraint(equation==1)

	objective=0
	y=p.new_variable(binary=True)
#	for e in G.edges():
#		for f in G.edges():
#			if are_parallel(e,f,n):
#				objective+=y[e,f]
	for e in G.edges():
		u,v,z=e
		parallels=nonenize_pairs(generate_parallels((u,v),n))
		for f in parallels:
			u,v,z=f
			if G.has_edge(u,v):
				objective+=y[e,f]
				p.add_constraint(x[e]+x[f]>=2*y[e,f])
		
	p.set_objective(objective)

	sol=p.solve()
	solution=p.get_values(x).items()
	R=[]
	for s in solution:
		if s[1]==1:
			R.append(s[0])
	H=Graph(R)

	while H.is_tree()==False:
		comps=H.connected_components()
		for comp in comps:
			X=H.subgraph(comp)
			if X.size() > X.order()-1:
				equation=0
				for e in X.edges():
					equation+=x[e]
				p.add_constraint(equation<=X.order()-1)
		sol=p.solve()
		solution=p.get_values(x).items()
		R=[]
		for s in solution:
			if s[1]==1:
				R.append(s[0])
		H=Graph(R)

	if should_print:	
		H.show(layout="circular")
		print("number of parallel pairs: "+str(sol))
	lista=[0]
	u=0
	while H.order()>=2:
		v=H.neighbors(u)[0]
		H.delete_vertex(u)
		lista.append(v)
		u=v
	return lista
	
def arranging_minimizing_parallels(n,k,should_print):

	p = MixedIntegerLinearProgram(maximization=False,solver=my_solver)

	G=graphs.CompleteGraph(n+1)
	for e in G.edges():
		if e[1]-e[0] > k:
			G.delete_edge(e)
	
#	variável da aresta: x[e]=1 implica que e está no nosso caminho
	x = p.new_variable(binary=True)

#	equações dos vértices
	for u in G.vertices():
		equation=0
		for e in G.edges_incident(u):
			equation+=x[e]
		if u==0:
			p.add_constraint(equation==1)
		else:
			p.add_constraint(equation<=2)
	
	for i in range(1,k+1):
		equation=0
		for e in G.edges():
			if e[1]-e[0] == i:
				equation+=x[e]
		if i>=2*k-n+1:
			p.add_constraint(equation==2)
		else:
			p.add_constraint(equation==1)

	objective=0
	y=p.new_variable(binary=True)
#	for e in G.edges():
#		for f in G.edges():
#			if are_parallel(e,f,n):
#				objective+=y[e,f]
	for e in G.edges():
		u,v,z=e
		parallels=nonenize_pairs(generate_parallels((u,v),n))
		for f in parallels:
			u,v,z=f
			if G.has_edge(u,v):
				objective+=y[e,f]
				p.add_constraint(x[e]+x[f]>=2*y[e,f])
		
	p.set_objective(objective)

	sol=p.solve()
	solution=p.get_values(x).items()
	R=[]
	for s in solution:
		if s[1]==1:
			R.append(s[0])
	H=Graph(R)

	while H.is_tree()==False:
		comps=H.connected_components()
		for comp in comps:
			X=H.subgraph(comp)
			if X.size() > X.order()-1:
				equation=0
				for e in X.edges():
					equation+=x[e]
				p.add_constraint(equation<=X.order()-1)
		sol=p.solve()
		solution=p.get_values(x).items()
		R=[]
		for s in solution:
			if s[1]==1:
				R.append(s[0])
		H=Graph(R)

	if should_print:	
		H.show(layout="circular")
		print("number of parallel pairs: "+str(sol))
	lista=[0]
	u=0
	while H.order()>=2:
		v=H.neighbors(u)[0]
		H.delete_vertex(u)
		lista.append(v)
		u=v
	return lista
	
def arranging_maximizing_small_cuts(n,k,should_print):

	p = MixedIntegerLinearProgram(maximization=False,solver=my_solver)

	G=graphs.CompleteGraph(n+1)
	for e in G.edges():
		if e[1]-e[0] > k:
			G.delete_edge(e)
	
#	variável da aresta: x[e]=1 implica que e está no nosso caminho
	x = p.new_variable(binary=True)

#	equações dos vértices
	for u in G.vertices():
		equation=0
		for e in G.edges_incident(u):
			equation+=x[e]
		if u==0:
			p.add_constraint(equation==1)
		else:
			p.add_constraint(equation<=2)
	
	for i in range(1,k+1):
		equation=0
		for e in G.edges():
			if e[1]-e[0] == i:
				equation+=x[e]
		if i>=2*k-n+1:
			p.add_constraint(equation==2)
		else:
			p.add_constraint(equation==1)

	objective=0
	y=p.new_variable(integer=True)
	z=p.new_variable(binary=True)
#	for e in G.edges():
#		for f in G.edges():
#			if are_parallel(e,f,n):
#				objective+=y[e,f]
	for i in range(n):
		for j in range(i+1,n+1):
			equation=0
			for e in G.edges():
				u,v,l=e
				if  u in range(1,i) and v in range(j+1,n+1):
					equation+=x[e]
			p.add_constraint(equation==y[i,j])
			p.add_constraint(y[i,j] + G.size()*z[i,j] <=G.size()+1)
			p.add_constraint(z[i,j]<=y[i,j])
			objective+=z[i,j]
	p.set_objective(objective)

	sol=p.solve()
	solution=p.get_values(x).items()
	R=[]
	for s in solution:
		if s[1]==1:
			R.append(s[0])
	H=Graph(R)

	while H.is_tree()==False:
		comps=H.connected_components()
		for comp in comps:
			X=H.subgraph(comp)
			if X.size() > X.order()-1:
				equation=0
				for e in X.edges():
					equation+=x[e]
				p.add_constraint(equation<=X.order()-1)
		sol=p.solve()
		solution=p.get_values(x).items()
		R=[]
		for s in solution:
			if s[1]==1:
				R.append(s[0])
		H=Graph(R)
		
	solution=p.get_values(y).items()
	for s in solution:
		if s[1]==1:
			print(s[0])
		

	if should_print:	
		H.show(layout="circular")
		print("number of parallel pairs: "+str(sol))
	lista=[0]
	u=0
	while H.order()>=2:
		v=H.neighbors(u)[0]
		H.delete_vertex(u)
		lista.append(v)
		u=v
	return lista
	
def distance(e,n):
	u,v=e
	d=v-u
	return min(d,n+1-d)	
	
def generate_parallels(e,n):
	parallels=[]
	cruzou=False
	u,v=e
	if distance((u,v),n)<=2:
		ustart=u-1
		vstart=v+1
	else:
		ustart=u
		vstart=v
	
	if e==(0,n):
		ustart=1
		vstart=n-1
	if e==(0,n-1):
		ustart=1
		vstart=n-2
	if e==(1,n):
		ustart=2
		vstart=n-1

	parallels.append((ustart,vstart))
	u,v=(ustart,vstart)	
	while distance((u,v),n)>2 and cruzou==False:
		if u==n:
			u=0
			cruzou=True
		else:
			u+=1
		if v==0:
			v=n
			cruzou=True
		else:
			v-=1
		f=(min(u,v),max(u,v))
		parallels.append(f)
		u,v=f
	while distance((u,v),n)>2:
		u-=1
		v+=1
		f=(u,v)
		parallels.append(f)
		
	u,v=(ustart,vstart)
	while distance((u,v),n)>2 and cruzou==False:
		if u==0:
			u=n
			cruzou=True
		else:
			u-=1
		if v==n:
			v=0
			cruzou=True
		else:
			v+=1
		f=(min(u,v),max(u,v))
		parallels.append(f)
		u,v=f
	while distance((u,v),n)>2:
		u+=1
		v-=1
		f=(u,v)
		parallels.append(f)
		
	return parallels	
	
def nonenize_pairs(pairs):
	result=[]
	for e in pairs:
		u,v=e
		result.append((u,v,None))
	return result
