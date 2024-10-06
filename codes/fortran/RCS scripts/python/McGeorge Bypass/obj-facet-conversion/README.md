# Obj/Facet Conversion

## Introduction

The **Obj/Facet Conversion** application is for converting `.obj` (alias mesh) files into Mercury MoM `.facet` files.

Examples of `.obj` and `.facet` files are in the `sample` directory.  For the format of `.obj` files, please see the following link: https://en.wikipedia.org/wiki/Wavefront_.obj_file.  For the format of `.facet` files, please reference Appendix B in the _Mercury Method of Moments and MMViz User's Guide_.

There are two versions of this application.  This simpler, first version is for converting simple `.obj` files into `.facet`.  The enhanced version handles more elaborate files and
allows for conversion of `.facet` files into `.obj` files as well as `.obj` files into `.facet`.

## Simple Version

The `Obj2Facet_Python2.py` file contains the application for simple conversion of `.obj` files into `.facet` file.  (Note that this file is for Python 2; there is a
corresponding file, `Obj2Facet_Python3.py` for Python 3.)  Following is the command to run the application:

```
python Obj2Facet_Python2.py <input-file-name> [<output-file-name>]
```

where `<input-file-name>` is the name of the input `.obj` file and `<output-file-name>` is the name of the output `.facet` file.  If `<output-file-name>` is not specified, the
application will base the output file name on the input file name (e.g., if the input file name is `sample.obj`, the output file name, if not specified, will be `sample.facet`).

Following is a sample execution:

```
python Obj2Facet.Python.py sample/sample.obj output.facet
```

## Enhanced Version

The enhanced version allows for conversion of not only `.obj` files into `.facet` files but also `.facet` files into `.obj` files.  (The enhanced version is for Python 3; it will
not work in Python 2.)  The code for this application is in the `ObjFacetConversion` directory, and following is the commands to run the application:

```
cd ObjFacetConversion
python obj_facet_conversion.py <input-file-name> [<output-file-name>]
```

where `<input-file-name>` is the name of the input `.obj` or `.facet` file and `<output-file-name>` is the name of the output `.obj` or `.facet` file.
If `<output-file-name>` is not specified, the application will base the output file name on the input file name (e.g., if the input file name is `sample.facet`, the output file name, if not specified, will be `sample.obj`).

The enhanced version requires `.obj` files to have `.obj` file extensions (e.g., `sample.obj`) and `.facet` files to have `.facet` file extension (e.g., `sample.facet`).  

### Unit Tests

Use the following command to run the unit tests in the enhanced version:

```
cd ObjFacetConversion
python -m unittest
```
