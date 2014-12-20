import networkx as nx
import random
class solver:
    
    def __init__(self, G, delta = 1.0/3):
        """
        Args:
        delta: "cleanness" parameter. Defaults to the assumed value of 1/44
        given in the paper
        """
        self.__G__ = G
        
        self.__reset_caches__()
        self.__clusters__ = None
        self.__delta__ = delta
        
        self.__clusters__ = self.run()
        print str(len(self.__clusters__))
        f = open('test/clusters_o7_8068.txt', 'w')
        for m in range(0,len(self.__clusters__)):
            list_c = list(self.__clusters__[m])
            str_c = ','.join(map(str, list_c)) 
            f.write(str_c+"\n")
        f.close()    
        
    def __reset_caches__(self):
        self.__G_nodes__ = set(self.__G__.nodes())
        self.__N_plus_cache__ = dict()
        
    def __remove_cluster__(self, C):
        self.__G__.remove_nodes_from(C)
        self.__reset_caches__()
        
    def positive_neighbours(self, u):
        """
        Returns N+(u), or {u} U {v : e(u, v) = +}
        Args:
        G: a networkx graph where presence of edges indicates a + edge
        u: a node in G
        """
        if u in self.__N_plus_cache__:
            return self.__N_plus_cache__[u]
        
        res = set([u])
        for i in self.__G__.neighbors(u):
            res.add(i)
            
        self.__N_plus_cache__[u] = res
        return res
    
    def delta_good(self, v, C, delta):
        """
        Returns true if v is delta-good with respect to C, where C is a cluster in
        G
        Args:
        G: a networkx graph
        v: a vertex v in G
        C: a set of vertices in G
        delta: "cleanness" parameter
        """
        Nv = self.positive_neighbours(v)
        
        return (len(Nv & C) >= (1-delta) * len(C) and len(Nv & (self.__G_nodes__ - C)) <= delta * len(C))
    
    def run(self):
        """
        Runs the "cautious algorithm" from the paper.
        """
        if self.__clusters__ is None:
            self.__clusters__ = []
            
            while len(self.__G_nodes__) > 0:
                # Make sure we try all the vertices until we run out
                vs = random.sample(self.__G_nodes__, len(self.__G_nodes__))
                Av = None
                for v in vs:
                    Av = self.positive_neighbours(v).copy()
                    # Vertex removal step
                    for x in self.positive_neighbours(v):
                        if not self.delta_good(x, Av, self.__delta__):
                            Av.remove(x)
                    # Vertex addition step
                    Y = set(y for y in self.__G_nodes__
                    if self.delta_good(y, Av, self.__delta__))
                    Av = Av | Y
                    
                    if len(Av) > 0:
                        break
                    
                # Second quit condition: all sets Av are empty
                if len(Av) == 0:
                    break
                self.__clusters__.append(Av)
                self.__remove_cluster__(Av)
                
        # add all remaining vertices as singleton clusters
            for v in self.__G_nodes__:
                self.__clusters__.append(set([v]))
    
        return self.__clusters__
    
if __name__ == "__main__":
    #main(sys.argv);
    G= nx.Graph()
    lines = [line.strip() for line in open('test/edge_labels_extracted_o7_8068.txt')]
    print len(lines);
    for x in lines:
       m=x.split(', ')
       if m[0]=='1':
           G.add_edge(int(m[1]),int(m[2]))
       else:
           G.add_node(int(m[1])) 
           G.add_node(int(m[2]))
              

    print str(G.nodes())
    x = solver(G) 