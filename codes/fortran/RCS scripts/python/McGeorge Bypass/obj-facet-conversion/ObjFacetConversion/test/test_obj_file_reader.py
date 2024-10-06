from obj_model       import ObjModel
from obj_file_reader import ObjFileReader

import os
import unittest

class ObjFacetReaderTest(unittest.TestCase):

    FILE_NAME_INPUT_OBJECT = "..\sample\sample.obj"

    def test_read(self):
        objFileReader: ObjFileReader = ObjFileReader()
        objModel: ObjModel = objFileReader.read(ObjFacetReaderTest.FILE_NAME_INPUT_OBJECT)

        self.assertEqual(345, len(objModel.vertices))
        self.assertAlmostEqual(  3658.000000, objModel.vertices[  0].x)
        self.assertAlmostEqual(-10450.000000, objModel.vertices[  0].y)
        self.assertAlmostEqual(  -457.200012, objModel.vertices[  0].z)
        self.assertAlmostEqual(     1.000000, objModel.vertices[  0].w)
        self.assertAlmostEqual( 16157.329102, objModel.vertices[344].x)
        self.assertAlmostEqual(-20900.000000, objModel.vertices[344].y)
        self.assertAlmostEqual(     0.000000, objModel.vertices[344].z)
        self.assertAlmostEqual(     1.000000, objModel.vertices[344].w)

        self.assertEqual(686, len(objModel.faces))
        self.assertEqual(  3, len(objModel.faces[  0].vertex_indices))
        self.assertEqual( 62, objModel.faces[  0].vertex_indices[0]  )
        self.assertEqual( 14, objModel.faces[  0].vertex_indices[1]  )
        self.assertEqual(338, objModel.faces[  0].vertex_indices[2]  )
        self.assertEqual(  3, len(objModel.faces[685].vertex_indices))
        self.assertEqual(175, objModel.faces[685].vertex_indices[0]  )
        self.assertEqual(164, objModel.faces[685].vertex_indices[1]  )
        self.assertEqual(130, objModel.faces[685].vertex_indices[2]  )

if __name__ == '__main__':
    unittest.main()
