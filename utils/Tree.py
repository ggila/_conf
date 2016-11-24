from collections import deque
import csv

class Node(object):

    ATTRIBUTES = set((
                      'id',               # unique identifier
                      'name',             # string
                      'parent',           # parent id
                      'path',             # list of parents from root to node
                      'children',         # list of children id
                      'nb_subchild',      # number of subchildren (!= len(children))
                     ))


    def __init__(self, id_, **kwargs):
        '''
        `id` is mandatory (and must be comparable)
        `kwargs` contains optionnal attribute
        
        Raise AttributeError if unexpected attribute in kwargs

        Copy at first information then check its consistency (to be done)
        '''

        self.id = id_

        # raise AttributeError if unexpected attribute:
        key_kwargs = set(kwargs.keys())
        if key_kwargs.difference(Node.ATTRIBUTES):
            raise AttributeError

        # init expected attributes not found in kwargs
        to_init = Node.ATTRIBUTES.difference(key_kwargs)
        self._init(to_init)

        # copy expected attributes found in kwargs
        to_copy = Node.ATTRIBUTES.intersection(key_kwargs)
        self.update(**{k:kwargs[k] for k in to_copy})

        #self.check_consistency()

    def _init(self, to_init):
        if 'children' in to_init:
            self.children = Node.new_default_node_children()
        if 'nb_subchild' in to_init:
            self.nb_subchild = 0

    def update(self, **kwargs):
        for k, v in kwargs.items():
            setattr(self, k, v)

    def get_defined_attribute(self):
        return [attr for attr in Node.ATTRIBUTES
                              if (hasattr(self, attr)
                                  and getattr(self, attr))]

    def __repr__(self):

        def attr_to_dict(self, attr):
            return "{attr}='{value}'".format(
                            attr=attr,
                            value=getattr(self, attr))

        name = self.__class__.__name__

        attr_lst = self.get_defined_attribute()
        attr_formated = ', '.join([attr_to_dict(self, attr)
                                        for attr in attr_lst])

        return '{class_name}({attr})'.format(class_name=name, attr=attr_formated)

    @staticmethod
    def new_default_node_children():
        return set()

    def add_parent(self, parent):
        pass


class Tree(object):

    NODE_ATTRIBUTES = Node.ATTRIBUTES

    def __init__(self, nodes):
        '''
            'nodes': list of dicts describing Node
        '''
#        self.check_consistency(nodes)
        import datetime
        self.nodes = dict()
        i = 0
        start = datetime.datetime.now()
        for node in nodes:
            id_ = node.pop('id')
            self.add_node(id_, node)
            i += 1
            if i % 5000 == 0:
                print '{nb} attributes in tree ({time}s)'.format(nb=i, time=(datetime.datetime.now() - start).seconds)
        print 'done: {nb} attributes in tree ({time}s)'.format(nb=i, time=(datetime.datetime.now() - start).seconds)
        print datetime.datetime.now()

#SHOULD ADAPT (DEFAULT_NODE_KEY)
#    @classmethod
#    def from_file(cls, file_):
#        with open(file_) as f:
#            csv_lines = csv.reader(f)
#            format_ = csv_lines.next()
#            self.csv_reader = self._handle_csv_format(format_)
#            for line in csv_lines:
#                node = self.csv_reader(line)
#                nodes.append(node)
#        return cls(**node)
#
#    def _handle_csv_format(self, format_):
#        '''
#            Check format and return function allowing to read wanted field from input
#        '''
#        for field in DEFAULT_NODE_KEY:
#            assert (field in format_), "'id', 'name' or 'parent_id' not define in taxo"
#        indices = [format_.index(field) for field in DEFAULT_NODE_KEY]
#
#        def csv_reader(line):
#            return {field:line[index] for field, index in zip(Node.ATTRIBUTES, indices)}
#
#        return csv_reader

    def __getitem__(self, node_id):
        return self.nodes[node_id]

    def __iter__(self):
        return dict.__iter__(self.nodes)

    def items(self):
        return self.nodes.items()

    def add_node(self, id_, node_dict):
        if id_ not in self:                 # node might have already been created (by one of its children)
            self.nodes[id_] = Node(id_)
        self[id_].update(**node_dict)
        if 'parent' in node_dict:
            parent = node_dict['parent']
            self._handle_root(parent, id_)
            if 'children' not in node_dict:
                self._set_children_from_parent(parent, id_)
    
    def _handle_root(self, parent, id_):
        if self[id_].parent == id_:
            if hasattr(self, 'root'):
                raise AttributeError
            self.root = self[id_]

    def _set_children_from_parent(self, parent, id_):
        if parent not in self.nodes:
            self.nodes[parent] = Node(parent)
        self[parent].add_child(id_)

    def count_subchild(self, node):
        import sys
        recursion_limit = sys.getrecursionlimit()
        sys.setrecursionlimit(len(self.nodes))
        count = self._count_subchild_rec(node, 0)
        sys.setrecursionlimit(recursion_limit)
        return count

    def _count_subchild_rec(self, node, count):
        children = node.children
        count += len(children)
        for child_id in children:
            count += self._count_subchild_rec(self[child_id], 0)
        return count

    def get_nb_subchild(self):

        def add_subchild_count(self, node):
            if len(node.children) != 0:
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

        self.trasverse_tree(func, filter_args, visited, to_visit)
