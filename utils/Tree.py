from collections import deque

POSSIBLE_INPUT = ('id_node',
                  'name',
                  'parent_id',
                  'path',
                  'id_path',
                  'children_id')

class Node(object):

    def __init__(self, **kwargs):
        for k, v in kwargs:
            if k not in POSSIBLE_INPUT:
                raise:
                    KeyError
            setattr(self, k, v)
        self.check_consistency()

    def __repr__(self):
        return 'Node({}, {}, {})'.format(self.id_node,
                                         self.name,
                                         self.id_parent,)

    def add_child(self, child):
        if not hasattr(self, 'children'):
            self.child = []
        if child not in self.child:
            self.child.append(child)

    def add_parent(self, parent):
        pass



class Tree(object):

    def __init__(self, nodes):
        self.nodes = dict()
        for node in nodes:
            self._add_node(*node)
        self.check_consistency()

    def __getitem__(self, node_id):
        return self.nodes[node_id]

    def __iter__(self):
        return dict.__iter__(self.nodes)

    def _add_node(self, **node):
        new_node = Node(**node)
        if new_node.id_node == new_node.id_parent:
            self.root = new_node
        self.nodes[id_node] = new_node

    def check_root(self):
        assert hasattr(self, 'root')

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
                        to_visit,
                        visited=set(),
                        filter_args=default_args,
                        ordering_node=lambda x:x,
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
            - ordering_node: node.children are sorted with this
                             function before being pushed on queue
            -toptobottom: bfs or dfs
        '''

        def apply_func():
            available_args = self, node, visited, to_visit
            filtered_args = filter_args(available_args)
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

