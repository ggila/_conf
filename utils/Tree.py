#!/usr/bin/env python

'''
    Python Tree (connected circuitless graph) Implementation
'''

from collections import deque
import json
import csv

(_BFS, _WFS0 = range(2)

class Node(object):

    ATTRIBUTES = set((
                      'id',               # unique identifier
                      'name',             # string
                      'parent',           # parent id
                      'path',             # list of parents from root to node
                      'children',         # list of children id
                      'nb_subchild',      # number of subchildren (!= len(children))
                     ))

    INIT_FUNC = {
                    # k: attributes which need to be init
                    # v: function returning init value
                    'path': list,
                    'children': set,
                    'nb_subchild': int,
                }


    def __init__(self, id_, **kwargs):
        '''
        `id` is mandatory (and must be comparable)
        `kwargs` contains optionnal attribute
        
        Raise AttributeError if unexpected attribute in kwargs

        Copy at first information then check its consistency
        '''

        self.id = id_

        kwargs_attr = set(kwargs.keys())
        all_attr = Node.ATTRIBUTES 
        init_attr = set(Node.INIT_FUNC)


        # raise AttributeError if unexpected attribute:
        unknown_attr = set.difference(kwargs_attr, all_attr)
        if unknown_attr:
            raise AttributeError, 'unknown attributes: {attrs}'.format(attrs=unknown_attr)

        # copy expected attributes found in kwargs
        to_copy = set.intersection(kwargs_attr, all_attr)
        self.update(**{k:kwargs[k] for k in to_copy})

        # init expected attributes not found in kwargs
        to_init = set.difference(init_attr, kwargs_attr)
        self._init(*to_init)

        #self.check_consistency() TODO

    def _init(self, *attrs):
        init = Node.INIT_FUNC
        for attr in attrs:
            if attr in init:
                val = init[attr]()
                setattr(self, attr, val)

    def update(self, **kwargs):
        for k, v in kwargs.items():
            setattr(self, k, v)

    def _get_defined_attribute(self):
        '''
            Return list of non-null self attributes name
            (shoul)
        '''
        return [attr for attr in Node.ATTRIBUTES
                              if (hasattr(self, attr)
                                  and getattr(self, attr))]

    def add_child(self, id_child):
        if id_child not in self.children:
            self.children.add(id_child)

    def __repr__(self):

        def to_str(self, attr):
            return '{attr}="{value}"'.format(
                            attr=attr,
                            value=getattr(self, attr))

        name = self.__class__.__name__

        attr_lst = self._get_defined_attribute()
        formated_attr = [to_str(self, attr) for attr
                                                    in attr_lst
                                                    if attr != 'id']
        return '{class_name}("{id_}", {other_attr})'.format(
                                class_name=name,
                                id_=self.id, 
                                other_attr=', '.join(formated_attr))


    def __eq__(self, other):
        if isinstance(other, self.__class__):
            return self.__dict__ == other.__dict__
        return NotImplemented

    def __ne__(self, other):
        if isinstance(other, self.__class__):
            return not self.__eq__(other)
        return NotImplemented


class Tree(object):

    NODE_ATTRIBUTES = Node.ATTRIBUTES

    def __init__(self, nodes=[]):
        '''
            'nodes': list of dicts describing Node
        '''
        self.nodes = dict()
        #self.complete_node_attributes(nodes)
        #print 'node setup ok'.format(len(self.nodes))
        for node in nodes:
            id_ = node.pop('id')
            self.nodes[id_] = Node(id_, **node)
        self._check()
        print 'tree ok'.format(len(self.nodes))

    def _check(self):
        for id_, node in self.items():
            if node.parent == id_:
                if hasattr(self, 'root'):
                    raise AttributeError
                self.root = node
                return
        if not hasattr(self, 'root'):
            print 'no root find'

    def __getitem__(self, node_id):
        return self.nodes[node_id]

    def __iter__(self):
        return dict.__iter__(self.nodes)

    def items(self):
        return self.nodes.items()


    #TOUPDATE
    def add_node(self, id_, node_dict):
        if id_ not in self:                 # node might have already been created (by one of its children)
            self.nodes[id_] = Node(id_)
        self[id_].update(**node_dict)
        if 'parent' in node_dict:
            parent = node_dict['parent']
            self._handle_root(parent, id_)
            if 'children' not in node_dict:
                self._set_children_from_parent(parent, id_)
    
    def _set_children_from_parent(self, parent, id_):
        if parent not in self.nodes:
            self.nodes[parent] = Node(parent)
        self[parent].add_child(id_)

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

    def _bfs(self,
                        starting_node,
                        func,
                        order=_BFS):
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

        def trasverse_tree_rec(self,
                            to_visit,
                            func,
                            toptobottom:
                            visited):
       
            node = to_visit.popleft()
            to_visit.extend(node.children)

        if not toptobottom:
            func(self, node, visited, to_visit, visiting)

        self.trasverse_tree(func, filter_args, visited, to_visit)

        if toptobottom:
            func(self, node, visited, to_visit, visiting)


    def __eq__(self, other):
        if isinstance(other, self.__class__):
            if len(self.nodes) != len(other.nodes):
                return False
            for k in self.nodes:
                if self[k] != other[k]:
                    return False
            return True
        return NotImplemented

    def __ne__(self, other):
        if isinstance(other, self.__class__):
            return not self.__eq__(other)
        return NotImplemented
