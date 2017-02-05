#!/usr/bin/env python

import csv

from translator import CsvTranslator

'''
    Python Tree (connected circuitless graph) Implementation
'''

from levenshtein import levenshtein

def _compute_format_field_func(attr_len):
    def format_this(value):
        n = str(attr_len)
        string = ('{value:'+n+'.'+n+'}' if isinstance(value, str)
                                        else '{value:<'+n+'}')
        return string.format(value=value)
    return format_this

NODE_ATTRIBUTES = set((
                       'id',             # unique identifier
                       'name',           # string
                       'parent',         # parent id
                       'path',           # list of parents from root to node
                       'pathname',       # string representing path
                       'children',       # list of children id
                       'weight',         # number of subchildren (!= len(children))
                      ))

KIN_RELATIONSHIP = set((
                        'parent',
                        'path',
                        'children',
                      ))

INIT_FUNC = {
                # k: attributes which need to be init
                # v: function returning init value
                'path': list,
                'children': set,
                'weight': int,
            }

assert KIN_RELATIONSHIP.issubset(NODE_ATTRIBUTES)
assert set(INIT_FUNC).issubset(NODE_ATTRIBUTES)

class Node(object):


    PRETTY_FORMAT_FUNC = {
            field: _compute_format_field_func(len_)
                        for (field, len_) in [('id', 7),
                                              ('name', 20),
                                              ('parent', 7),
                                              ('path', 60),
                                              ('children', 30),
                                              ('weight', 7)]
                         }

    @property
    def is_root(self):
        return self.parent == self.id

    @property
    def to_dict(self):
        return {
            k: getattr(self, k) for k in self._get_defined_attribute()
        }

    def _pretty_format(self, fields):
        format_ = [Node.PRETTY_FORMAT_FUNC[f](getattr(self, f)) for f in fields]
        return '\t'.join(format_)

    def _get_defined_attribute(self):
        '''
            Return list of non-null self attributes name
        '''
        return [attr for attr in NODE_ATTRIBUTES
                              if hasattr(self, attr)]

    def _update(self, **kwargs):
        for k, v in kwargs.items():
            setattr(self, k, v)

    def __init__(self, id_, **kwargs):
        '''
        `id` is mandatory (and must be comparable)

        `kwargs` contains optionnal attribute
        
        Raise AttributeError if unexpected attribute in kwargs

        Copy at first information
        (todo: check consistency afterward)
        '''

        self.id = id_

        kwargs_attr = set(kwargs.keys())
        all_attr = NODE_ATTRIBUTES 
        init_attr = set(INIT_FUNC)


        # raise AttributeError if unexpected attribute:
        unknown_attr = set.difference(kwargs_attr, all_attr)
        if unknown_attr:
            raise AttributeError, 'unknown attributes: {attrs}'.format(attrs=unknown_attr)

        # copy expected attributes found in kwargs
        to_copy = set.intersection(kwargs_attr, all_attr)
        self._update(**{k:kwargs[k] for k in to_copy})

        # init expected attributes not found in kwargs
        to_init = set.difference(init_attr, kwargs_attr)
        self._init(*to_init)

    def _init(self, *attrs):
        init = INIT_FUNC
        for attr in attrs:
            if attr in init:
                val = init[attr]()
                setattr(self, attr, val)

    def __repr__(self):

        def attr_to_str(self, attr):
            return '{attr}="{value}"'.format(
                            attr=attr,
                            value=getattr(self, attr))

        name = self.__class__.__name__

        attr_lst = self._get_defined_attribute()
        formated_attr = [attr_to_str(self, attr) for attr
                                                 in attr_lst
                                                 if attr != 'id']
        return '{class_name}("{id_}", {other_attr})'.format(
                                class_name=name,
                                id_=self.id, 
                                other_attr=', '.join(formated_attr))


    def __eq__(self, other):
        if self.is_root and other.is_root:
            return True
        if isinstance(other, self.__class__):
            return self.__dict__ == other.__dict__
        return NotImplemented

    def __ne__(self, other):
        if isinstance(other, self.__class__):
            return not self.__eq__(other)
        return NotImplemented


class Tree(object):

    DEFAULT_ROOT = {
                'id': 344,
                'name': 'ROOT',
                'parent': 344,
            }

    def write_csv(self, file_, fields):
        '''
            Write all nodes of a Tree in a csv file.
            Only the specified fields are written.
        '''
        def __format_csv_row(node, fields):
            return [getattr(node, attr) for attr in fields]

        def __write_header(writer):
            writer.writerow(fields)

        with open(file_, 'wb') as f:
            writer = csv.writer(f)
            __write_header(writer)
            for id_ in self.nodes:
                row = __format_csv_row(self[id_], fields)
                csv_writer.writerow(row)

    @property
    def weight_is_set(self):
        return not (self.root.weight == 0)

    @property
    def path_is_set(self):
        return not (self.root.path == [])

    def add_node(self, node):
        '''
            Add node without any check nor process
            Overwrite node with same id
        '''
        id_ = node.pop('id')
        self.nodes[id_] = Node(id_, **node)
        node['id'] = id_

    def get_node(self, node):
        '''
            For now, id is an int, this function should be rewritten
            if it changes.

            Return node from:
                * id 
                * name (if not found, might retrun node with closest name)
                * node (return itself)
        '''
        if isinstance(node, int):
            return self[node]
        elif isinstance(node, str):
            match = self.find_close_name(node)
            if not match:
                print 'node not found'
            elif len(match) > 1:
                print 'multiple attibutes matches'
            else:
                return match.pop()
        elif isinstance(node, Node):
            return node

    def extract_subtree(self, starting_node):
        ''' starting_node must be an id '''

        def get_subtree(self, starting_node):
            subtree = self._bfs_seq(starting_node)
            nodes = [self[id_].to_dict for id_ in subtree]
            return nodes

        def node_to_root(node_dict):
            node_dict['parent'] = root['id']
            node_dict['children'].add(root['id'])

        root, nodes = self[starting_node].to_dict, get_subtree(self, starting_node)
        node_to_root(root)
        return Tree(nodes=nodes)

    def del_subtree(self, starting_node_id):

        parent_id = self[starting_node_id].parent
        self[parent_id].children.discard(starting_node_id)
        
        bfs_seq = self._bfs_seq(starting_node_id)

        for id_ in bfs_seq:
            self.nodes.pop(id_)

        self._compute_weight()

    def add_subtree(self, subtree, plug_node_id=DEFAULT_ROOT['id']):
        '''
            plug subtree root to self plug_node
        '''
        assert plug_node_id in self, 'unkown node id: {}'.format(plug_node_id)

        subtree.root.children.discard(subtree.root.id)
        subtree.root.parent = plug_node_id
        self[plug_node_id].children.add(subtree.root.id)
        nodes = [nodes.to_dict for _, nodes in subtree.nodes.items()]
        self._copy_nodes(nodes)
        self._compute_path()
        self._compute_weight()

    def _bfs_seq(self, starting_node_id, toptobottom=True):
        '''
            Traverse tree and return list of visited node.
            https://en.wikipedia.org/wiki/Breadth-first_search

            order in which the nodes are listed:

                          1
                         /|\
                        2 3 4
                       /| |  \
                      5 6 7   8
                     /|   |    \
                    9 10  11   12

            (reverse order if toptobottom=False)

            `visited_set` is here just for perf:
            For a tree with ~ 60000 nodes, _bfs_seq take 100ms instead of 19.3s
        '''

        visited_lst = [starting_node_id]
        visited_set = set((starting_node_id, ))
        current = 0

        while current < len(visited_lst):

            # visit current node
            node_id = visited_lst[current]

            # add children to to_visit
            node = self[node_id]
            new_to_visit = set.difference(node.children, visited_set)
            visited_set.update(new_to_visit)
            visited_lst.extend(new_to_visit)

            # go to next node to be visited:
            current += 1

        if not toptobottom:
            visited_lst.reverse()

        return visited_lst


    def print_node(self, node):
        node = self._get_node(node)
        if not node:
            return
        print node.name
        print ''
        print 'id: {}'.format(node.id)
        print 'path: {}'.format(node.pathname)
        print 'parent id: {}'.format(node.parent)
        print 'weight: {}'.format(node.weight)
        print 'nb_children: {}'.format(len(node.children))

    @property
    def _keyint(self):
        def __gKeyint():
            yield 0
            for a in self.nodes:
                try:
                    yield int(a)
                except:
                    pass
        return lst(__gKeyint())

    def _get_min_key(self):
        return min(self._keyint)

    def _get_max_key(self):
        return max(self._keyint)

    def print_close_name(self, name, threshold=3):
        nodes = self.find_close_name(name, threshold)
        for node in nodes:
            self.print_node(node)

    def show_children(self, node, fields=['id', 'name','weight']):
        node = self._get_node(node)
        if not node:
            return
        child_lst = list(node.children)
        self.print_node(node)
        print ''
        print 'child:'
        if not self.weight_is_set:
            self._compute_weight()
        for child_id in sorted(child_lst, key=lambda x: self[x].weight, reverse=True):
            print self[child_id]._pretty_format(fields)

    def _complete_tree(self, attr):
        if 'children' not in attr:
            if 'parent' in attr:
                self._set_children_from_parent()
        self._fill_node_attributes()

    def _fill_node_attributes(self):
        self._compute_weight()
        self._compute_path()
        self._compute_pathname()

    def find_close_name(self, name, threshold=3):
        res = []
        for _, node in self.items():
            if levenshtein(name, node.name) < threshold:
                res.append(node)
        return res

    def _check_root(self):
        for id_, node in self.items():
            if node.parent == id_:
                if hasattr(self, 'root'):
                    raise AttributeError
                node.children.add(node.id)
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

    def _set_children_from_parent(self):
        print 'init children'
        for id_, node in self.items():
            assert node.parent in self, 'node {} as an unkown parent'.format(id_)
            self[node.parent].children.add(id_)

    def _compute_pathname(self):
        if not self.path_is_set:
            self._compute_path()
        for id_, node in self.items():
            pathname = [self[id_].name for id_ in node.path]
            node.pathname = ' > '.join(pathname[::-1])

    def _compute_weight(self):
        bfs_seq = self._bfs_seq(self.root.id, toptobottom=False)
        node_seq = (self[id_] for id_ in bfs_seq)
        self.root.weight = 0
        for node in node_seq:
            node.weight =  1 + sum([self[child_id].weight
                                        for child_id in node.children])

    def _compute_path(self):
        bfs_seq = self._bfs_seq(self.root.id)
        self.root.path = [self.root.id]
        for id_ in bfs_seq[1:]:
            node = self[id_]
            parent_path = self[node.parent].path
            node.path = [node.id] + parent_path

    def _copy_nodes(self, nodes):
        '''
            nodes is a list of dict
        '''
        for node in nodes:
            self._check_add_node(node)
            id_ = node.pop('id')
            self.nodes[id_] = Node(id_, **node)

    def _check_add_node(self, node):
        if node['id'] in self:
            self_node = self[node_id]
            assert node == node_id, 'cannot had node {}: already exist with different value'.format(node.id)

    @classmethod
    def _from_csv(cls, file_):
        '''
            Used for instantiate Tree from csv file
        '''

        def __get_csv_reader_facilities(file_):
            csv_lines = csv.reader(file_)
            header = csv_lines.next()
            translator = CsvTranslator(header)
            return csv_lines, translator


        nodes = []

        with open(file_) as f:

            csv_line, translator = __get_csv_reader_facilities(f)

            for nb_line, line in enumerate(csv_lines):
                tree_node = translator.csv_reader(line, nb_line + 1)  # +1 for header line
                nodes.append(tree_node)

        return Tree(nodes=nodes)

    def __init__(self, **kwargs):
        '''
            __init__ does not accept more than one named argument

            kwargs might contains as keys:

            - 'nodes': list of dicts describing Node

            - 'csv': path to a csv file (string) representing
                     a list of nodes

            In any case, nodes must have a root node
            (root has itself as parent and child)

            If no argument is given, a tree with just a root node is returned
        '''

        legal_kwargs = set(('nodes', 'csv'))

        def __check(kwargs):
            kwargs = set(kwargs)
            assert set.intersection(kwargs, legal_kwargs) > 1
            assert set.difference(kwargs, legal_kwargs) != 0

        __check(kwargs)

        if 'nodes' in kwargs:
            nodes = kwargs['nodes']
        elif 'csv' in kwargs:
            nodes = self._from_csv(kwargs['csv'])
        else:
            nodes = [Tree.DEFAULT_ROOT]

        def __setup_tree_nodes(nodes):
            self.nodes = dict()
            defined_attributes = nodes[0].keys() if len(nodes) != 0 else []
            for node in nodes:
                self.add_node(node)

        __setup_tree_nodes(nodes)

        self._check_root()

        defined_attributes = self.root._get_defined_attribute()
        self._complete_tree(defined_attributes)
         
#        self._check_consistency()

    def __eq__(self, other):
        if isinstance(other, self.__class__):
            if len(self.nodes) != len(other.nodes):
                return False
            if set(self.nodes.keys()) != set(other.nodes.keys()):
                return self
            self._fill_node_attributes()
            other._fill_node_attributes()
            for k in self.nodes:
                if self[k] != other[k]:
                    return False
            return True
        return NotImplemented

    def __ne__(self, other):
        if isinstance(other, self.__class__):
            return not self.__eq__(other)
        return NotImplemented
