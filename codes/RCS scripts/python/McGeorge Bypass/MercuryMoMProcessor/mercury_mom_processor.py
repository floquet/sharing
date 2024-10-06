from mercury_mom_output_file_reader import MercuryMoMOutputFileReader
from result_set                     import ResultSet

import dash
import dash_core_components as dcc
import dash_html_components as html
import glob
import os
import plotly.graph_objects as go

FILE_NAME_INPUT : str = r'sample\sphereCourse.4112.txt'
PATH_NAME_OUTPUT: str = r'output'
TITLE           : str = 'Sphere: '

LAMBDA         : str = chr(0x03bb)
PHI            : str = chr(0x03c6)
THETA          : str = chr(0x03b8)

if __name__ == '__main__':

    INDEX_THETA_THETA = 0
    INDEX_PHI_THETA   = 1
    INDEX_THETA_PHI   = 2
    INDEX_PHI_PHI     = 3

    if os.path.exists(PATH_NAME_OUTPUT):
        for file in glob.glob(os.path.join(PATH_NAME_OUTPUT, '*')):
            os.remove(file)
    else:
        os.makedirs(PATH_NAME_OUTPUT)

    output_file_reader: MercuryMoMOutputFileReader = MercuryMoMOutputFileReader()
    results           : [ResultSet]                = output_file_reader.read(FILE_NAME_INPUT)

    for index in [INDEX_THETA_THETA,
                  INDEX_PHI_THETA  ,
                  INDEX_THETA_PHI  ,
                  INDEX_PHI_PHI    ]:

        frequencies   : [float] = []
        values_by_phi : {}      = {}

        for result in results:
            frequencies.append(result.frequency)
            for result_data in result.data:
                phi_value: int = int(result_data.phi)
                if phi_value not in values_by_phi:
                    values_by_phi[phi_value] = []

                if index == INDEX_THETA_THETA:
                    values_by_phi[phi_value].append(abs(result_data.theta_theta))
                elif index == INDEX_PHI_THETA:
                    values_by_phi[phi_value].append(abs(result_data.phi_theta))
                elif index == INDEX_THETA_PHI:
                    values_by_phi[phi_value].append(abs(result_data.theta_phi))
                elif index == INDEX_PHI_PHI:
                    values_by_phi[phi_value].append(abs(result_data.phi_phi))


        heatmap_x_data: [float] = frequencies
        heatmap_y_data: [int]   = sorted(values_by_phi.keys())
        heatmap_z_data: []      = []
        for phi in heatmap_y_data:
            heatmap_z_data.append(values_by_phi[phi])

        heatmap               = go.Heatmap(x          = heatmap_x_data,
                                           y          = heatmap_y_data,
                                           z          = heatmap_z_data,
                                           colorscale = 'hsv'         )
        figure                = go.Figure(data = heatmap)
        title           : str = ''
        output_file_name: str = ''
        if index == INDEX_THETA_THETA:
            output_file_name = os.path.join(PATH_NAME_OUTPUT, 'theta-theta.png')
            title            = f'{TITLE}: |{THETA}-{THETA}|'
        elif index == INDEX_PHI_THETA:
            output_file_name = os.path.join(PATH_NAME_OUTPUT, 'phi-theta.png')
            title            = f'{TITLE}: |{PHI}-{THETA}|'
        elif index == INDEX_THETA_PHI:
            output_file_name = os.path.join(PATH_NAME_OUTPUT, 'theta-phi.png')
            title = f'{TITLE}: |{THETA}-{PHI}|'
        elif index == INDEX_PHI_PHI:
            output_file_name = os.path.join(PATH_NAME_OUTPUT, 'phi-phi.png')
            title = f'{TITLE}: |{PHI}-{PHI}|'
        figure.update_layout(title       = title             ,
                             xaxis_title = f'Frequency (MHz)',
                             yaxis_title = PHI               )
        figure.write_image(output_file_name)
        figure.show()
