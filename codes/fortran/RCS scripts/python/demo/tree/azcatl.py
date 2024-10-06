# https://gist.github.com/hrldcpr/2012250

import datetime         # timestamps
import os               # opeating system: file name and path
import pprint
from collections import defaultdict

def tree(): return defaultdict(tree)

taxonomy = tree()
taxonomy['Animalia']['Chordata']['Mammalia']['Carnivora']['Felidae']['Felis']['cat']
taxonomy['Animalia']['Chordata']['Mammalia']['Carnivora']['Felidae']['Panthera']['lion']
taxonomy['Animalia']['Chordata']['Mammalia']['Carnivora']['Canidae']['Canis']['dog']
taxonomy['Animalia']['Chordata']['Mammalia']['Carnivora']['Canidae']['Canis']['coyote']
taxonomy['Plantae']['Solanales']['Solanaceae']['Solanum']['tomato']
taxonomy['Plantae']['Solanales']['Solanaceae']['Solanum']['potato']
taxonomy['Plantae']['Solanales']['Convolvulaceae']['Ipomoea']['sweet potato']

# convert to standard disctionaries for printing
def dicts(t): return {k: dicts( t[k] ) for k in t}

# print hierachy
pprint.pprint( dicts( taxonomy ) ) # https://docs.python.org/3/library/pprint.html

print( "\n", datetime.datetime.now( ) )
print( "source: %s/%s" % ( os.getcwd( ), os.path.basename( __file__ ) ) )

# l127914@pn1249300.lanl.gov:tree $ python azcatl.py 
# {'Animalia': {'Chordata': {'Mammalia': {'Carnivora': {'Canidae': {'Canis': {'coyote': {},
#                                                                             'dog': {}}},
#                                                       'Felidae': {'Felis': {'cat': {}},
#                                                                   'Panthera': {'lion': {}}}}}}},
#  'Plantae': {'Solanales': {'Convolvulaceae': {'Ipomoea': {'sweet potato': {}}},
#                            'Solanaceae': {'Solanum': {'potato': {},
#                                                       'tomato': {}}}}}}
#
#  2018-12-03 20:01:17.769421
# source: /Volumes/Tlaltecuhtli/repos/GitHub/topa-development/python/tree/azcatl.py
