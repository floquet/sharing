from abc                 import ABC, abstractmethod
from file_read_exception import FileReadException
from typing              import Any

class FileReader(ABC):

#region Constructors

    def __init__(self):
        super().__init__()

#endregion

#region Public Methods

    @abstractmethod
    def read(self, file_name: str) -> Any:
        pass

#endregion

#region Protected Methods

    def _to_integer(self, s: str) -> int:
        try:
            return int(s)
        except ValueError as e:
            raise FileReadException(e)

#endregion