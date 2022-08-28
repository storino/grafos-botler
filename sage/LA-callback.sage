#!/bin/env sage
# -*- coding: utf-8 -*-
import gurobipy as gp
from gurobipy import GRB

def mycallback(model, where):
    """
    This function checks whether the incumbent solution found by Gurobi has a
    cycle or not. If a cycle was found, then this function adds a constraint

    that is violated by the current solution.

    To be more precise, if a cycle C is found in the current solution,
    then this function adds the following constraint

      ∑ x_{e, 0} ≤ |E(C)| - 1
    e ∈ E(C)
    """

    if where == GRB.Callback.MIPSOL:

        vals = model.cbGetSolution(model._x)
        
        G = Graph()
        for (pair, val) in vals.items():
            e,c = pair
            if val > 0:
                u,v,label=e
                G.add_edge((u,v,c))
        
        #G.show(color_by_label=True,layout="circular")
        
        Delta = max(G.degree())
        colors = range(ceil((Delta+1)/2))
        
        dic = {}
        
        for c in colors:
            dic[c] = []
        
        for e in G.edges():
            u,v,color = e
            dic[color].append(e)

        cycles = []
        for c in colors:
            H = Graph(dic[c])
            components = H.connected_components()
            for comp in components:
                comp_graph = H.subgraph(comp)
                is_forest, cycle = comp_graph.is_forest(certificate=True)
                if not is_forest:
                    csize = len(cycle)
                    cycle.append(cycle[0])
                    cycle_edges=[]
                    for i in range(csize):
                        u=cycle[i]
                        v=cycle[i+1]
                        if u < v:
                            cycle_edges.append((u,v))
                        else:
                            cycle_edges.append((v,u))
                    cycles.append(cycle_edges)
                    
        for cycle_edges in cycles:
            for c in colors:
                expr = 0
                for u,v in cycle_edges:
                    expr += model._x[((u,v,None),c)]
                model.cbLazy(expr <= csize - 1)
            #print("restriction added on cycle",cycle)
        
class Model:

    def __init__(self, G):

        self.model = gp.Model("linear arboricity")
        self.model.setParam('OutputFlag', 0)
        self.G = G
        self.Delta = max(G.degree())
        self.colors = range(ceil((self.Delta+1)/2))

        self._init_x_variables()

        # The next lines are defining some variables inside the model object so
        # that they can be accessed in the callback (yeah.. I'm breaking
        # encapsulation).  That's not very pretty, but it's the way it's
        # suggested by the Gurubi Another solution would be to define global
        # variables.
        
        self.model._x = self.x
        self.model._G = self.G

        self._add_constr_vertex_color_degree()
        self._add_constr_edge_color()

    def _init_x_variables(self):
        """
              ⎧1,  if e ∈ E(G) is selected
        x_e = ⎨
              ⎩0,  otherwise
        """
        indices = [(e,c) for e in self.G.edges() for c in self.colors]
        #print(indices)
        self.x = self.model.addVars(indices, lb=0.0, ub=1.0, vtype=GRB.BINARY, name="x")

    def _add_constr_vertex_color_degree(self):
        """
        Every vertex has degree at most 2 in each color, and 0 has degree precisely 1

        """
            
        for u in self.G.vertices():
            for c in self.colors:
                equation=0
                for e in self.G.edges_incident(u):
                    equation+=self.x[e,c]
                self.model.addConstr(equation<=2, name="color degree")

    def _add_constr_edge_color(self):
        """
        Some edge have to repeat once, and some edge do not repeat

        """
        
        for e in self.G.edges():
            equation=0
            for c in self.colors:
                equation+=self.x[e,c]
            self.model.addConstr(equation==1, name="each edge")

    def solve(self):

        self.model.write("modelo_debug.lp")

        # ⚠ if you plan to use lazyConstraints in Gurobi,
        #     you must set the following parameter to 1
        self.model.Params.lazyConstraints = 1

        # to use an lazyConstraint `foo`, you must pass it
        # as a parameter in the function optimize
        self.model.optimize(mycallback)
        
    def color(self):
        if self.model.status != GRB.OPTIMAL:
            return []

        for e in self.G.edges():
            for c in self.colors:
                if self.x[e,c].x >0.1:
                    self.G.set_edge_label(e[0],e[1],c)
                    
    def uncolor(self):
        for e in self.G.edges():
            self.G.set_edge_label(e[0],e[1],None)
                    
    def color_graphs(self):
        
        dic = {}
        
        for c in self.colors:
            dic[c] = []
        
        for e in self.G.edges():
            u,v,color = e
            dic[color].append(e)

        graphs=[]
        for c in self.colors:
            H = Graph(dic[c])
            graphs.append(H)
            
        return graphs

    def show(self):

        self.color()
        
        self.G.show(color_by_label=True,layout="circular")
        
def test_file(input_path,output_path):
    input_file = open(input_path)
    output_file = open(output_path,'a')
    counter = 0
    counterexamples = 0
    for x in input_file:
        G = Graph(x)
        M = Model(G)
        try:
            counter+=1
            if (counter%10000) == 0:
                print(counter)
            M.solve()
        except:
            counterexamples+=1
            out_file.write(x)
    input_file.close()
    output_file.close()
    print("tested "+str(counter)+" graphs, and found "+str(counterexamples)+" counterexamples")

from sage.graphs.graph_coloring import linear_arboricity

