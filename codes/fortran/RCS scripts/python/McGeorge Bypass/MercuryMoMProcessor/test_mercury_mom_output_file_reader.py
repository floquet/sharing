from mercury_mom_output_file_reader import MercuryMoMOutputFileReader
from result_set                     import ResultSet

import unittest

class TestMercuryMoMOutputFileReader(unittest.TestCase):
    """ The TestMercuryMoMOutputFileReader class represents the test case for the MercuryMoMOutputFileReader class. """

#region Constants

    __FILE_NAME_TEST: str = 'sample/sphereCourse.4112.txt'
    """ the name of the test file """


#endregion

    def test_read(self):
        output_file_reader: MercuryMoMOutputFileReader = MercuryMoMOutputFileReader()
        results           : [ResultSet]                = output_file_reader.read(TestMercuryMoMOutputFileReader.__FILE_NAME_TEST)

        self.assertEqual(100, len(results))

        self.assertAlmostEqual(10.00E+00 , results[0].frequency  )
        self.assertAlmostEqual(29.98E+00 , results[0].lambdaValue)
        self.assertAlmostEqual(209.58E-03, results[0].k          )

        self.assertEqual(361, len(results[0].data))

        self.assertAlmostEqual( 90.0000       , results[0].data[  0].theta           )
        self.assertAlmostEqual(  0.0000       , results[0].data[  0].phi             )
        self.assertAlmostEqual(  0.2333228E-01, results[0].data[  0].theta_theta.real)
        self.assertAlmostEqual(  0.1410688E-03, results[0].data[  0].theta_theta.imag)
        self.assertAlmostEqual(  0.8868390E-04, results[0].data[  0].phi_theta.real  )
        self.assertAlmostEqual(  0.5353989E-05, results[0].data[  0].phi_theta.imag  )
        self.assertAlmostEqual(  0.8868393E-04, results[0].data[  0].theta_phi.real  )
        self.assertAlmostEqual(  0.5354086E-05, results[0].data[  0].theta_phi.imag  )
        self.assertAlmostEqual(  0.2275015E-01, results[0].data[  0].phi_phi.real    )
        self.assertAlmostEqual(  0.1270486E-03, results[0].data[  0].phi_phi.imag    )

        self.assertAlmostEqual( 90.0000       , results[0].data[360].theta           )
        self.assertAlmostEqual(360.0000       , results[0].data[360].phi             )
        self.assertAlmostEqual(  0.2333228E-01, results[0].data[360].theta_theta.real)
        self.assertAlmostEqual(  0.1410688E-03, results[0].data[360].theta_theta.imag)
        self.assertAlmostEqual(  0.8868390E-04, results[0].data[360].phi_theta.real  )
        self.assertAlmostEqual(  0.5353989E-05, results[0].data[360].phi_theta.imag  )
        self.assertAlmostEqual(  0.8868393E-04, results[0].data[360].theta_phi.real  )
        self.assertAlmostEqual(  0.5354086E-05, results[0].data[360].theta_phi.imag  )
        self.assertAlmostEqual(  0.2275015E-01, results[0].data[360].phi_phi.real    )
        self.assertAlmostEqual(  0.1270486E-03, results[0].data[360].phi_phi.imag    )

        self.assertEqual(361, len(results[99].data))

        self.assertAlmostEqual( 90.0000       , results[99].data[  0].theta           )
        self.assertAlmostEqual(  0.0000       , results[99].data[  0].phi             )
        self.assertAlmostEqual(  0.2885610E+00, results[99].data[  0].theta_theta.real)
        self.assertAlmostEqual( -0.1011976E+01, results[99].data[  0].theta_theta.imag)
        self.assertAlmostEqual(  0.5899617E+00, results[99].data[  0].phi_theta.real  )
        self.assertAlmostEqual( -0.4689567E+00, results[99].data[  0].phi_theta.imag  )
        self.assertAlmostEqual(  0.5899619E+00, results[99].data[  0].theta_phi.real  )
        self.assertAlmostEqual( -0.4689569E+00, results[99].data[  0].theta_phi.imag  )
        self.assertAlmostEqual( -0.7161536E+00, results[99].data[  0].phi_phi.real    )
        self.assertAlmostEqual(  0.3769876E+00, results[99].data[  0].phi_phi.imag    )

        self.assertAlmostEqual( 90.0000       , results[99].data[360].theta           )
        self.assertAlmostEqual(360.0000       , results[99].data[360].phi             )
        self.assertAlmostEqual(  0.2885597E+00, results[99].data[360].theta_theta.real)
        self.assertAlmostEqual( -0.1011976E+01, results[99].data[360].theta_theta.imag)
        self.assertAlmostEqual(  0.5899608E+00, results[99].data[360].phi_theta.real  )
        self.assertAlmostEqual( -0.4689567E+00, results[99].data[360].phi_theta.imag  )
        self.assertAlmostEqual(  0.5899605E+00, results[99].data[360].theta_phi.real  )
        self.assertAlmostEqual( -0.4689562E+00, results[99].data[360].theta_phi.imag  )
        self.assertAlmostEqual( -0.7161548E+00, results[99].data[360].phi_phi.real    )
        self.assertAlmostEqual(  0.3769866E+00, results[99].data[360].phi_phi.imag    )

if __name__ == '__main__':
    unittest.main()
