from file_read_exception import FileReadException
from result_data         import ResultData
from result_set          import ResultSet
from typing              import Pattern

import io
import re

class MercuryMoMOutputFileReader(object):
    """ The MercuryMomOutputFileReader class represents readers that read output text files from Mercury MoM. """

#region Constants

    __EXPECTED_UNIT_FREQUENCY: str = "MHz"
    __EXPECTED_UNIT_K        : str = "m-1"
    __EXPECTED_UNIT_LAMBDA   : str = "m"

    __COLUMN_NAME_THETA      : str = 'Theta'
    __COLUMN_NAME_PHI        : str = 'Phi'
    __COLUMN_NAME_THETA_THETA: str = 'Theta-Theta'
    __COLUMN_NAME_PHI_THETA  : str = 'Phi-Theta'
    __COLUMN_NAME_THETA_PHI  : str = 'Theta-Phi'
    __COLUMN_NAME_PHI_PHI    : str = 'Phi-Phi'

    __PATTERN_FREQUENCY   : Pattern[str] = re.compile(r'^\s*Freq\s+='   )
    __PATTERN_K           : Pattern[str] = re.compile(r'^\s*k\s+='      )
    __PATTERN_LAMBDA      : Pattern[str] = re.compile(r'^\s*Lambda\s+=' )
    __PATTERN_BACKSCATTER : Pattern[str] = re.compile(r'^BACKSCATTER'   )
    __PATTERN_COLUMN_NAME : Pattern[str] = re.compile(r'\(.*?\)'        )
    __PATTERN_DATA        : Pattern[str] = re.compile(r'\((.+?),(.+?)\)')

#endregion

#region Constructors

    def __init__(self) -> None:
        """ Initializes this reader. """

#endregion

#region Public Methods

    def read(self, file_name: str) -> [ResultSet] :
        """ Reads a specified file.

            Args:
                file_name (str): the name of the file to read
            Returns:
                [ResultSet]: the read results
            Raises:
                FileReadException: if this method failed to read the specified file
        """

        results: [ResultSet]  = []

        try:
            with io.open(file_name, 'r') as file:
                column_names: [str]     = None
                line        : str       = file.readline()
                result_set  : ResultSet = None

                while line:
                    line = line.strip()
                    if len(line) > 0:
                        if MercuryMoMOutputFileReader.__PATTERN_FREQUENCY.search(line):
                            result_set = ResultSet()
                            result_set.frequency = self.__parse_frequency_line(line)
                        elif MercuryMoMOutputFileReader.__PATTERN_K.search(line):
                            result_set.k = self.__parse_k_line(line)
                        elif MercuryMoMOutputFileReader.__PATTERN_LAMBDA.search(line):
                            result_set.lambdaValue = self.__parse_lambda_line(line)
                        elif result_set is not None:
                            if (',' in line):
                                if column_names is None:
                                    column_names = [column_name.strip() for column_name in MercuryMoMOutputFileReader.__PATTERN_COLUMN_NAME.sub('', line).split(',')]
                                else:
                                    data_row: [str] = [data_value.strip() for data_value in MercuryMoMOutputFileReader.__PATTERN_DATA.sub(r'(\1 \2)', line).split(',')]
                                    if len(data_row) == len(column_names):
                                        result_data: ResultData = self.__parse_data_row(data_row    ,
                                                                                        column_names)
                                        result_set.data.append(result_data)
                                    else:
                                        results.append(result_set)
                                        column_names = None
                                        result_set   = None
                            elif not MercuryMoMOutputFileReader.__PATTERN_BACKSCATTER.search(line):
                                results.append(result_set)
                                column_names = None
                                result_set   = None
                    line = file.readline()
        except Exception as e:
            raise FileReadException(e)

        return results

#endregion

#region Private Methods

    def __parse_complex(self, s: str) -> complex:
        """ Parses a complex value.

            Args:
                s  the string to parse
            Returns:
                complex: the resulting complex value
            Raises:
                FileReadException: if the specified string is not a valid complex value
        """

        result: complex = None
        try:
            values: [str] = [value.strip() for value in s.replace('(', '').replace(')', '').split()]
            if len(values) == 2:
                result = complex(float(values[0]),
                                 float(values[1]))
        except Exception as e:
            result = None

        if result is None:
            raise FileReadException(f'"{s}" is not a valid complex number.')

        return result

    def __parse_data_row(self               ,
                         data_row    : [str],
                         column_names: [str]) \
                         -> ResultData:
        """ Processes a specified data row.

            Args:
                data_row ([str])      : the data row to parse
                column_names ([str])  : the names of the columns in the data row to parse
            Returns:
                ResultData: the parsed data
            Raises:
                FileReadException  if this method failed to parse the specified row
        """

        result_data: ResultData = ResultData()

        if len(data_row) != len(column_names):
            raise FileReadException('Invalid number of columns.')

        for data_value_index in range(len(data_row)):
            data_value : str = data_row[data_value_index]
            column_name: str = column_names[data_value_index]

            if column_name == MercuryMoMOutputFileReader.__COLUMN_NAME_THETA:
                result_data.theta = float(data_value)
            elif column_name == MercuryMoMOutputFileReader.__COLUMN_NAME_PHI:
                result_data.phi = float(data_value)
            elif column_name == MercuryMoMOutputFileReader.__COLUMN_NAME_THETA_THETA:
                result_data.theta_theta = self.__parse_complex(data_value)
            elif column_name == MercuryMoMOutputFileReader.__COLUMN_NAME_PHI_THETA:
                result_data.phi_theta = self.__parse_complex(data_value)
            elif column_name == MercuryMoMOutputFileReader.__COLUMN_NAME_THETA_PHI:
                result_data.theta_phi = self.__parse_complex(data_value)
            elif column_name == MercuryMoMOutputFileReader.__COLUMN_NAME_PHI_PHI:
                result_data.phi_phi = self.__parse_complex(data_value)
            else:
                raise FileReadException(f'Unexpected column "{column_name}".')
        return result_data

    def __parse_frequency_line(self, line: str) -> float:
        """ Parses the frequency from a specified line.

            Args:
                line (str): the line to parse
            Returns:
                float: the parsed frequency
            Raises:
                FileReadException  if this method failed to parse the specified line
        """

        frequency: float = 0.0
        tokens   : [str] = line.split()
        if (len(tokens) >= 4):
            frequency = float(tokens[2])
            unit      = tokens[3]
            if unit != MercuryMoMOutputFileReader.__EXPECTED_UNIT_FREQUENCY:
                raise FileReadException(f'Invalid frequency unit "{unit}".')
        return frequency

    def __parse_k_line(self, line: str) -> float:
        """ Parses the k from a specified line.

            Args:
                line (str): the line to parse
            Returns:
                float: the parsed k
            Raises:
                FileReadException  if this method failed to parse the specified line
        """

        k: float = 0.0
        tokens   : [str] = line.split()
        if (len(tokens) >= 4):
            k = float(tokens[2])
            unit      = tokens[3]
            if unit != MercuryMoMOutputFileReader.__EXPECTED_UNIT_K:
                raise FileReadException(f'Invalid k unit "{unit}".')
        return k

    def __parse_lambda_line(self, line: str) -> float:
        """ Parses the lambda from a specified line.

            Args:
                line (str): the line to parse
            Returns:
                float: the parsed lambda
            Raises:
                FileReadException  if this method failed to parse the specified line
        """

        lambdaValue: float = 0.0
        tokens   : [str] = line.split()
        if (len(tokens) >= 4):
            lambdaValue = float(tokens[2])
            unit      = tokens[3]
            if unit != MercuryMoMOutputFileReader.__EXPECTED_UNIT_LAMBDA:
                raise FileReadException(f'Invalid lambda unit "{unit}".')
        return lambdaValue

#endregion
