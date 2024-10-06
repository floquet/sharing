from facet_model       import FacetModel
from facet_file_reader import FacetFileReader

import datetime
import os
import unittest

class FacetFacetReaderTest(unittest.TestCase):

    FILE_NAME_INPUT_FACET = "..\sample\sample.facet"

    def test_read(self):
        facetFileReader: FacetFileReader = FacetFileReader()
        facetModel     : FacetModel      = facetFileReader.read(FacetFacetReaderTest.FILE_NAME_INPUT_FACET)

        self.assertEqual("FACET FILE V3.4", facetModel.format)
        self.assertEqual(datetime.datetime(2017, 9, 11, 15, 53, 12), facetModel.creation_time)
        self.assertEqual("", facetModel.platform)

        self.assertEqual(1, len(facetModel.parts))
        self.assertFalse(facetModel.parts[0].mirrored)
        self.assertEqual(345, len(facetModel.parts[0].vertices))
        self.assertAlmostEqual(  3658.000000, facetModel.parts[0].vertices[  0].x)
        self.assertAlmostEqual(-10450.000000, facetModel.parts[0].vertices[  0].y)
        self.assertAlmostEqual(  -457.200012, facetModel.parts[0].vertices[  0].z)
        self.assertAlmostEqual( 16157.329102, facetModel.parts[0].vertices[344].x)
        self.assertAlmostEqual(-20900.000000, facetModel.parts[0].vertices[344].y)
        self.assertAlmostEqual(     0.000000, facetModel.parts[0].vertices[344].z)

        self.assertEqual(1, len(facetModel.parts[0].subparts))
        self.assertEqual("<PTW MeshSheet>", facetModel.parts[0].subparts[0].name)
        self.assertEqual(3, facetModel.parts[0].subparts[0].element_type.value)
        self.assertEqual(686, facetModel.parts[0].subparts[0].element_count)
        self.assertEqual(0, facetModel.parts[0].subparts[0].vertex_count)
        self.assertFalse(facetModel.parts[0].subparts[0].material_field_two_sided)
        self.assertFalse(facetModel.parts[0].subparts[0].vertex_parameter_present)
        self.assertFalse(facetModel.parts[0].subparts[0].vertex_normal_present)
        self.assertFalse(facetModel.parts[0].subparts[0].element_curvature_present)
        self.assertFalse(facetModel.parts[0].subparts[0].material_field_two_sided)
        self.assertEqual("", facetModel.parts[0].subparts[0].outer_region_id)
        self.assertEqual("", facetModel.parts[0].subparts[0].inner_region_id)
        self.assertEqual("", facetModel.parts[0].subparts[0].boundary_condition)
        self.assertEqual(686, len(facetModel.parts[0].subparts[0].faces))
        self.assertEqual(1, len(facetModel.parts[0].subparts[0].faces[0].material_ids))
        self.assertEqual("0", facetModel.parts[0].subparts[0].faces[0].material_ids[0])
        self.assertEqual(3, len(facetModel.parts[0].subparts[0].faces[0].vertex_indices))
        self.assertEqual(62, facetModel.parts[0].subparts[0].faces[0].vertex_indices[0])
        self.assertEqual(14, facetModel.parts[0].subparts[0].faces[0].vertex_indices[1])
        self.assertEqual(338, facetModel.parts[0].subparts[0].faces[0].vertex_indices[2])
        self.assertEqual(1, len(facetModel.parts[0].subparts[0].faces[685].material_ids))
        self.assertEqual("0", facetModel.parts[0].subparts[0].faces[685].material_ids[0])
        self.assertEqual(3, len(facetModel.parts[0].subparts[0].faces[685].vertex_indices))
        self.assertEqual(175, facetModel.parts[0].subparts[0].faces[685].vertex_indices[0])
        self.assertEqual(164, facetModel.parts[0].subparts[0].faces[685].vertex_indices[1])
        self.assertEqual(130, facetModel.parts[0].subparts[0].faces[685].vertex_indices[2])

if __name__ == '__main__':
    unittest.main()
