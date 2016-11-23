from collections import deque

POSSIBLE_INPUT = ('id',
                  'name',
                  'parent',
                  'path',
                  'id_path',
                  'children',
                  'nb_subchild')

class Node(object):

    def __init__(self, id_, **kwargs):
        self.node_attr = ['id']
        self.id = id_
        if len(kwargs) > 0:
            self.update(**kwargs)

    def update(self, **kwargs):
        for k, v in kwargs.items():
            if k not in POSSIBLE_INPUT:
                raise KeyError
            self.node_attr.append(k)
            setattr(self, k, v)
        #self.check_consistency()

    def __repr__(self):
        s = 'Node('
        s += ', '.join(["{field}='{value}'".format(field=field, value=getattr(self, field))
                            for field in POSSIBLE_INPUT 
                            if field in self.node_attr])
        s += ')'
        return s

    def add_child(self, id_child):
        if not hasattr(self, 'children'):
            self.children = []
            self.node_attr.append('children')
        if id_child not in self.children:
            self.children.append(id_child)

    def add_parent(self, parent):
        pass


class Tree(object):

    def __init__(self, nodes):
        '''
            'nodes': list of dicts describing Node
        '''
#        self.check_consistency(nodes)
        self.nodes = dict()
        for node in nodes:
            id_ = node.pop('id')
            self._add_node(id_, node)

    def __getitem__(self, node_id):
        return self.nodes[node_id]

    def __iter__(self):
        return dict.__iter__(self.nodes)

    def items(self):
        return self.nodes.items()

    def _add_node(self, id_, node_dict):
        if id_ not in self:
            self.nodes[id_] = Node(id_)
        self[id_].update(**node_dict)
        if self[id_].parent == id_:
            if hasattr(self, 'root'):
                raise AttributeError
            self.root = self[id_]

    def check_root(self):
        assert hasattr(self, 'root')

    def _add_child(self):
        for id_, node in self.items():
            assert (node.parent in self)
            self[node.parent].add_child(id_)

    def get_nb_subchild(self):

        for id_, node in self.items():
            node.nb_subchild = 0

        def add_subchild_count(self, node):
            if len(node.children != 0):
                node.nb_subchild = sum([self[subnode].nb_subchild for subnode
                                                                  in node.children])
            
        self.trasverse_tree(add_subchild_count,
                            deque((self.root, )),
                            filter_args=self.self_and_node,
                            toptobottom=False)


#    def _check_circuitless(self):
#        visited = set()
#        self._trasverse_tree(check_circuitless_rec, self.root, visited=visited)

#    @staticmethod
#    def _check_unvisited(visiting, visited):
#        assert (visiting not in visited)
#        visited.add(visiting)

    @staticmethod
    def default_args(self, visiting, visited, to_visit):
        '''
        filter args for trasverse_tree
        '''
        return {
            'self': self,
            'node': node,
            'visited': visited,
            'to_visit': to_visit
        }

    @staticmethod
    def self_and_node(self, visiting, visited, to_visit):
        return {
            'self': self,
            'node': visiting,
        }

#    @staticmethod
#    def __add_child(node):
#        self.nodes[node.parent] = node.id

    def count_subchild(self, id_):
        import sys
        recursion_limit = sys.getrecursionlimt()
        sys.setrecursionlimit(len(self.nodes))
        count = _count_subchild_rec(id_, 0)
        sys.setrecursionlimit(recursion_limit)
        return count

    def _count_subchild_rec(self, id_count):
        children = self[id_].children
        count += len(children)
        for child in children:
            count += self.count_subchild(child, 0)
        return count

    def trasverse_tree(self,
                        func,
                        to_visit,
                        visited=set(),
                        filter_args=default_args,
                        ordering_children=lambda x:x,
                        toptobottom=True,):
        '''
            traverse tree and apply func to each node

            args:
            - func: map function
            - to_visit: queue for next nodes to be visited, must be
                        initialized with the starting node (usually
                        root) as follows:
                            collections.deque((starting_node, ))
            - filter_args: function which filter func arguments
                           (must be a method of this class)
            - visited: set of nodes on which func has been applied
            - ordering_children: node.children are sorted with this
                                 function before being pushed on queue
            -toptobottom: bfs or dfs
        '''

        def apply_func():
            available_args = self, node, visited, to_visit
            filtered_args = filter_args(*available_args)
            func(**filtered_args)
            
        try:
            node = to_visit.popleft()
        except IndexError:
            return

        if toptobottom:
            apply_func()

        children = ordering_children(node.children)
        to_visit.extend(children)

        if not toptobottom:
            apply_func()

        self._trasverse_tree(func, filter_args, visited, to_visit)
