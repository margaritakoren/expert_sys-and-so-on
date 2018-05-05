class Prolog(object):

    def __init__(self, graph_dict=None):
        if graph_dict == None:
            graph_dict = {}
        self.__graph_dict = graph_dict

    def read_file(self):
        f = open('commands.txt')
        data = f.read()
        lines = data.split('\n')
        for line in lines:
            line = line.replace(' ','')
            if line[0] == '?': 
                if '&&' in line or '||' in line:
                    self.parse_formula(line[2:len(line)-1])
                else: self.parse_question(line[1:])
            else:
                fact = self.parse_line(line)
                if (',') in fact:
                    fact = self.parse_binary(fact)
                    self.add_edge(fact)
                else: self.add_vertex(fact)

    def parse_binary(self, b_line):
        b_line = b_line.replace(',','')
        l = []
        l.append(b_line[0])
        l.append(b_line[1])
        return l

    def parse_line(self, fact__):
        fact__ = fact__.replace(' ','')
        fact__ = fact__.replace('"', '')
        i = fact__.find('(')
        j = fact__.find(')')
        f_act = fact__[i + 1:j]
        return f_act

    def parse_formula(self, frml):
        by_parts = []
        if '&&' in frml:
            by_parts = self.formula_by_parts(frml, sign = '&&')
            print(by_parts[0] and by_parts[1])
        elif '||' in frml:
            by_parts = self.formula_by_parts(frml, sign = '||')
            print(by_parts[0] or by_parts[1])

    def formula_by_parts(self, f_ormula, sign):
        i = f_ormula.find(sign)
        parts = []
        s1, s2 = f_ormula[0:i], f_ormula[i + 2:len(f_ormula)]
        parts.append(s1)
        parts.append(s2)
        verity = []
        for part in parts:
            part = self.parse_line(part)
            if (',') in part:
                vec = self.parse_binary(part)
                verity.append(self.transitive_relation(vec))
            else:
                verity.append(part in self.__graph_dict)
        return verity

    def parse_question(self, l_ine):
        f_act = self.parse_line(l_ine)
        if (',') in f_act:
            f_act = self.parse_binary(f_act)
            print(self.transitive_relation(f_act))
        else:
            print(f_act in self.__graph_dict)

    def is_related(self, key, value):
        if key in self.__graph_dict:
            values = self.__graph_dict[key]
            if (value in values):
                return(True)
            return (False)
        else:
            #print("Факта", key, "не существует в системе")
            return(False)

    def transitive_relation(self, f__):
        key_1, value_1 = f__[0], f__[1]
        key_2, value_2 = f__[1], f__[0]
        return (self.is_related(key_1, value_1) or self.is_related(key_2, value_2))

    def vertices(self):
        """ returns the vertices of a graph """
        return list(self.__graph_dict.keys())

    def edges(self):
        """ returns the edges of a graph """
        return self.__generate_edges()

    def add_vertex(self, vertex):
        if vertex not in self.__graph_dict:
            self.__graph_dict[vertex] = []

    def add_edge(self, edge):
        (vertex1, vertex2) = tuple(edge)
        if vertex1 in self.__graph_dict:
            self.__graph_dict[vertex1].append(vertex2)
        else:
            self.__graph_dict[vertex1] = [vertex2]

    def __generate_edges(self):
        edges = []
        for vertex in self.__graph_dict:
            for neighbour in self.__graph_dict[vertex]:
                if {neighbour, vertex} not in edges:
                    edges.append({vertex, neighbour})
        return edges

    def __str__(self):
        res = "vertices: "
        for k in self.__graph_dict:
            res += str(k) + " "
        res += "\nedges: "
        for edge in self.__generate_edges():
            res += str(edge) + " "
        return res


if __name__ == "__main__":
    g = {}
    graph = Prolog(g)
    print("Результат:")
    graph.read_file()

    # print("Факты")
    # print(graph.vertices())

    # print("Связи")
    # print(graph.edges())
