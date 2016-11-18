from collections import deque

class Node(object):

    def __init__(self, id_node, id_parent, name):
        self.id_node = id_node
        self.id_parent = id_parent
        self.name = name

    def add(self, child):
        if not hasattr(self, 'children'):
            self.child = []
        if child not in self.child:
            self.child.append(child)

class Tree(object):

    def __init__(self, nodes):
        self.nodes = dict()
        for node in nodes:
            self._add_node(*node)
        self._set_children()
        self._check_circuitless()

    def __getitem__(self, node_id):
        return self.nodes[node_id]

    def __iter__(self):
        return dict.__iter__(self.nodes)

    def _add_node(self, id_node, id_parent, name):
        new_node = Node(id_node, id_parent, name)
        if id_node == id_parent:
            self.root = new_node
        self[id_node] = new_node

    def check_root(self):
        assert hasattr(self, 'root')

    def add_child(self):
        self.trasverse_tree(_add_child, self.root)

    @staticmethod
    def _add_child(visiting, visited):
       self[visiting.id_parent].append(visiting)

    def _check_circuitless(self):
        visited = set()
        self._trasverse_tree(check_circuitless_rec, self.root, visited=visited)

    @staticmethod
    def _check_unvisited(visiting, visited):
        assert (visiting not in visited)
        visited.add(visiting)

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

    def trasverse_tree(self,
                        func,
                        filter_args=default_args,
                        visited=set()
                        to_visit=deque([self.root]),
                        ordering_function=lambda x:x,
                        toptobottom=True,):
        '''
            traverse tree and apply func to each node

            args:
            - func: map function
            - filter_args: function which filter func arguments
                           (must be a method of this class)
            - visited: set of nodes on which func has been applied
            - to_visit: queue for node to visit
        '''

        def apply_func():
            args = self, node, visited, to_visit
            filtered_args = filter_args(args)
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

