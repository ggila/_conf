# coding: utf-8

from unittest import TestCase
from itertools import combinations
from random import randint
import mock
import copy

from tree import Node, Tree

# Tree test:
#
#               a
#              /|\
#             / | \                      1
#            aA aB aC                   /|\
#           /|   |   \                 2 3 4
#          / |   |    \               /| |  \
#        aAa aAb aBa  aCa            5 6 7   8
#        /|       |     \           /|   |    \
#       / |       |      \         9 10  11   12
#   aAaA aAaB   aBaA    aCaA
#

nodes = (
    {'id': 1,'name': 'a','parent': 1,'path': [1],'children': set([1,2,3, 4])},
    {'id': 2,'name': 'aA','parent': 1,'path': [2,1],'children': set([5,6])},
    {'id': 3,'name': 'aB','parent': 1,'path': [3,1],'children': set([7])},
    {'id': 4,'name': 'aC','parent': 1,'path': [4,1],'children': set([8])},
    {'id': 5,'name': 'aAa','parent': 2,'path': [5,2,1],'children': set([9,10])},
    {'id': 6,'name': 'aAb','parent': 2,'path': [6,2,1],'children': set()},
    {'id': 7,'name': 'aBa','parent': 3,'path': [7,3,1],'children': set([11])},
    {'id': 8,'name': 'aCa','parent': 4,'path': [8,4,1],'children': set([12])},
    {'id': 9,'name': 'aAaA','parent': 5,'path': [9,5,2,1],'children': set()},
    {'id': 10,'name': 'aAaB','parent': 5,'path': [10,5,2,1],'children': set()},
    {'id': 11,'name': 'aCaA','parent': 7,'path': [11,7,3,1],'children': set()},
    {'id': 12,'name': 'aCba','parent': 8,'path': [12,8,4,1],'children': set()},
)

# Small tree:
#
#      A
#     / \
#    /   \  
#   Aa    Ab
#

small_nodes = (
    {'id': 13,'name': 'A','parent': 13,'path': [13],'children': set([13,14,15])},
    {'id': 14,'name': 'Aa','parent': 13,'path': [14,13],'children': set()},
    {'id': 15,'name': 'Ab','parent': 13,'path': [15,13],'children': set()},
)

# Big tree:
#
#               a
#              /|\
#             / | \                      1
#            aA aB aC                   /|\
#           /|   |   \                 2 3 4
#          / |   |    \               /| |  \
#        aAa aAb aBa  aCa            5 6 7   8
#        /|       |    |\           /|   |   |\
#       / |       |    | \         9 10  11 12 13
#   aAaA aAaB   aBaA aCaA A                    | \
#                         |\                  14 15
#                         | \
#                        Aa Ab
#

big_nodes = copy.deepcopy(nodes) + copy.deepcopy(small_nodes)
# unset small_tree root
big_nodes[13-1]['parent'] = 8
big_nodes[13-1]['children'].remove(13)
# plug small_tree to the right tree node
big_nodes[8-1]['children'].add(13)


class NodeTest(TestCase):
    
    def setUp(self):
        self.nodes = copy.deepcopy(nodes)
        self.small_nodes = copy.deepcopy(small_nodes)

    def test_init(self):
        for node_dict in self.nodes:
            id_ = node_dict.pop('id')
            node = Node(id_, **node_dict)
            self.assertEqual(node.id, id_)
            for k, v in node_dict.items():
                self.assertEqual(getattr(node, k), v)

    def test_equal(self):
        for node in (self.nodes + self.small_nodes):
            id_ = node.pop('id')
            un = Node(id_, **node)
            deux = Node(id_, **node)
            self.assertEqual(un, deux)

    def test_not_equal(self):
        for node_1, node_2 in combinations((self.nodes + self.small_nodes), 2):
            n1, n2 = copy.copy(node_1), copy.copy(node_2)
            id_1, id_2 = n1.pop('id'), n2.pop('id')
            self.assertNotEqual(Node(id_1, **n1), Node(id_2, **node_2))

    def test_to_dict(self):
        for node in (self.nodes + self.small_nodes):
            id_ = node.pop('id')
            n = Node(id_, **node)
            node['id'] = id_
            node['weight'] = int()
            self.assertDictEqual(n.to_dict, node)


class TreeTest(TestCase):

    def setUp(self):

        self.nodes = copy.deepcopy(nodes)
        self.tree = Tree(nodes=copy.deepcopy(nodes))

        self.small_nodes = copy.deepcopy(small_nodes)
        self.small_tree = Tree(nodes=copy.deepcopy(small_nodes))

        self.big_nodes = copy.deepcopy(big_nodes)
        self.big_tree = Tree(nodes=copy.deepcopy(self.big_nodes))

    def test_tree_init(self):
        tree = self.tree
        self.assertEqual(tree.root.id, 1)
        self.assertEqual(tree.root.children, set([1,2,3,4]))
        self.assertEqual(set(tree.nodes), set(range(1,len(self.nodes)+1)))

    def test_bfs_seq(self):
        seq = self.tree._bfs_seq(1)
        self.assertEqual(seq[0], 1)
        self.assertEqual(set(seq[1:4]), set((2,3,4)))
        self.assertEqual(set(seq[4:8]), set((5,6,7,8)))
        self.assertEqual(set(seq[8:]), set((9,10,11,12)))

    def test_bfs_seq_bottomtotop(self):
        seq = self.tree._bfs_seq(1, toptobottom=False)
        self.assertEqual(set(seq[:4]), set((9,10,11,12)))
        self.assertEqual(set(seq[4:8]), set((5,6,7,8)))
        self.assertEqual(set(seq[8:-1]), set((2,3,4)))
        self.assertEqual(seq[-1], 1)

    def test_compute_weight(self):
        self.tree._compute_weight()
        self._check_weight()
        for id_, node in self.tree.items():
            node.weight = randint(1,1000)
        self.tree._compute_weight()
        self._check_weight()

    def _check_weight(self):
        self.assertEqual(self.tree[1].weight, 12)
        self.assertEqual(self.tree[2].weight, 5)
        self.assertEqual(self.tree[3].weight, 3)
        self.assertEqual(self.tree[4].weight, 3)
        self.assertEqual(self.tree[5].weight, 3)
        self.assertEqual(self.tree[6].weight, 1)
        self.assertEqual(self.tree[7].weight, 2)
        self.assertEqual(self.tree[8].weight, 2)
        self.assertEqual(self.tree[9].weight, 1)
        self.assertEqual(self.tree[10].weight, 1)
        self.assertEqual(self.tree[11].weight, 1)
        self.assertEqual(self.tree[12].weight, 1)

    def test_extract_subtree(self):
        tree = self.tree
        cp_tree = self.tree.extract_subtree(tree.root.id)
        self.assertEqual(tree, cp_tree)

    def test_add_subtree(self):
        self.tree.add_subtree(self.small_tree, 8)
        for id_, node in self.tree.nodes.items():
            self.assertEqual(node, self.big_tree[id_])
        self.assertEqual(self.tree, self.big_tree)

    def test_del_subtree(self):
        self.big_tree.del_subtree(self.small_tree.root.id)
        self.assertEqual(self.big_tree, self.tree)


if __name__ == '__main__':
    import unittest
    unittest.main()
