(* Content-type: application/vnd.wolfram.cdf.text *)

(*** Wolfram CDF File ***)
(* http://www.wolfram.com/cdf *)

(* CreatedBy='Mathematica 12.0' *)

(***************************************************************************)
(*                                                                         *)
(*                                                                         *)
(*  Under the Wolfram FreeCDF terms of use, this file and its content are  *)
(*  bound by the Creative Commons BY-SA Attribution-ShareAlike license.    *)
(*                                                                         *)
(*        For additional information concerning CDF licensing, see:        *)
(*                                                                         *)
(*         www.wolfram.com/cdf/adopting-cdf/licensing-options.html         *)
(*                                                                         *)
(*                                                                         *)
(***************************************************************************)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[      1088,         20]
NotebookDataLength[     25977,        618]
NotebookOptionsPosition[     26480,        615]
NotebookOutlinePosition[     26818,        630]
CellTagsIndexPosition[     26775,        627]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{

Cell[CellGroupData[{
Cell[BoxData[
 RowBox[{"Manipulate", "[", "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    RowBox[{"meanRCS", "=", 
     RowBox[{"Import", "[", "\"\<rcs-values.dat\>\"", "]"}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"pointer", " ", "to", " ", "data", " ", "file"}], " ", "*)"}], 
    "\[IndentingNewLine]", 
    RowBox[{"index", "=", 
     RowBox[{"\[Nu]", "-", "2"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"wavelegnth", " ", "in", " ", "meters"}], " ", "*)"}], 
    "\[IndentingNewLine]", 
    RowBox[{"\[Lambda]", "=", 
     RowBox[{"Round", "[", 
      FractionBox["\[DoubleStruckC]", 
       RowBox[{"\[Nu]", " ", "1000000"}]], "]"}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{
     "grab", " ", "rcs", " ", "at", " ", "specific", " ", "wavelength"}], " ",
      "*)"}], "\[IndentingNewLine]", 
    RowBox[{"rcs", "=", 
     RowBox[{"meanRCS", "[", 
      RowBox[{"[", "index", "]"}], "]"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"number", " ", "of", " ", "data", " ", "points"}], " ", "*)"}], 
    "\[IndentingNewLine]", 
    RowBox[{"\[CapitalTheta]", "=", 
     RowBox[{"Table", "[", "\[IndentingNewLine]", 
      RowBox[{
       RowBox[{"k", " ", 
        FractionBox["\[Pi]", "180"]}], "\[IndentingNewLine]", ",", 
       RowBox[{"{", 
        RowBox[{"k", ",", 
         RowBox[{"-", "180"}], ",", "180"}], "}"}]}], "]"}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"m", "=", 
     RowBox[{"Length", "[", "\[CapitalTheta]", "]"}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"center", " ", "on", " ", "nose", " ", 
      RowBox[{"(", 
       RowBox[{
        RowBox[{"yaw", " ", "angle", " ", "\[Alpha]"}], " ", "=", " ", "90"}],
        " ", ")"}]}], " ", "*)"}], "\[IndentingNewLine]", 
    RowBox[{"\[Sigma]", "=", 
     RowBox[{"RotateLeft", "[", 
      RowBox[{"rcs", ",", "180"}], "]"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{
     "characterize", " ", "variation", " ", "for", " ", "plot", " ", 
      "range"}], " ", "*)"}], "\[IndentingNewLine]", 
    RowBox[{"mx", "=", 
     RowBox[{"Max", "[", "\[Sigma]", "]"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"mn", "=", 
     RowBox[{"Min", "[", "\[Sigma]", "]"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"\[CapitalLambda]", "=", "1.1"}], ";", "\[IndentingNewLine]", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"top", ",", "bot"}], "}"}], "=", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"1.1", "mx"}], ",", 
       RowBox[{"0.9", "mn"}]}], "}"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"plot", " ", "subtitles"}], " ", "*)"}], "\[IndentingNewLine]", 
    RowBox[{"subtitle", "=", 
     RowBox[{"\"\<\!\(\*StyleBox[\"\[Nu]\",FontSlant->\"Italic\"]\) = \>\"", "<>", 
      RowBox[{"ToString", "[", "\[Nu]", "]"}], "<>", "\"\< MHz\>\""}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"subtitle", "=", 
     RowBox[{
     "subtitle", "<>", 
      "\"\<, \!\(\*StyleBox[\"\[Lambda]\",FontSlant->\"Italic\"]\) = \>\"", "<>", 
      RowBox[{"ToString", "[", "\[Lambda]", "]"}], "<>", "\"\< m\>\""}]}], 
    ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"scatter", " ", "plot", " ", "of", " ", "data", " ", "points"}], 
     " ", "*)"}], "\[IndentingNewLine]", 
    RowBox[{"z", "=", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"\[CapitalTheta]", ",", "\[Sigma]"}], "}"}], 
      "\[Transpose]"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"g000", "=", 
     RowBox[{"ListPlot", "[", 
      RowBox[{"z", ",", 
       RowBox[{"PlotStyle", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{"Purple", ",", 
          RowBox[{"Opacity", "[", "0.5", "]"}], ",", 
          RowBox[{"PointSize", "[", "0.005", "]"}]}], "}"}]}]}], "]"}]}], ";",
     "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"assemble", " ", "linear", " ", "system"}], " ", "*)"}], 
    "\[IndentingNewLine]", 
    RowBox[{"avector", "=", 
     RowBox[{"Table", "[", 
      RowBox[{
       RowBox[{"Cos", "[", 
        RowBox[{"j", " ", "\[Theta]"}], "]"}], ",", 
       RowBox[{"{", 
        RowBox[{"j", ",", "0", ",", "d"}], "}"}]}], "]"}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"A", "=", 
     RowBox[{"Table", "[", "\[IndentingNewLine]", 
      RowBox[{
       RowBox[{"Simplify", "[", 
        RowBox[{"avector", "/.", 
         RowBox[{"\[Theta]", "\[Rule]", 
          RowBox[{"\[CapitalTheta]", "[", 
           RowBox[{"[", "k", "]"}], "]"}]}]}], "]"}], "\[IndentingNewLine]", 
       ",", 
       RowBox[{"{", 
        RowBox[{"k", ",", "m"}], "}"}]}], "]"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{
      RowBox[{"compute", " ", "Fourier"}], "-", 
      RowBox[{"Bessel", " ", "coefficients"}]}], " ", "*)"}], 
    "\[IndentingNewLine]", 
    RowBox[{"c", "=", 
     RowBox[{"LeastSquares", "[", 
      RowBox[{"A", ",", "\[Sigma]"}], "]"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"approximation", " ", "function"}], " ", "*)"}], 
    "\[IndentingNewLine]", 
    RowBox[{"Clear", "[", "f", "]"}], ";", "\[IndentingNewLine]", 
    RowBox[{
     RowBox[{"f", "[", "\[Theta]_", "]"}], "=", 
     RowBox[{"c", ".", "avector"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"approximation", " ", "vector"}], " ", "*)"}], 
    "\[IndentingNewLine]", 
    RowBox[{"F", "=", 
     RowBox[{
      RowBox[{"f", "[", "\[Theta]", "]"}], "/.", 
      RowBox[{"\[Theta]", "\[Rule]", "\[CapitalTheta]"}]}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"residual", " ", "error"}], " ", "*)"}], "\[IndentingNewLine]", 
    RowBox[{"r", "=", 
     RowBox[{"\[Sigma]", "-", "F"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"R", "=", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"\[CapitalTheta]", ",", "r"}], "}"}], "\[Transpose]"}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"total", " ", "error"}], " ", "*)"}], "\[IndentingNewLine]", 
    RowBox[{"r2", "=", 
     RowBox[{"r", ".", "r"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"uncertainty", " ", "propagation"}], " ", "*)"}], 
    "\[IndentingNewLine]", 
    RowBox[{"\[Epsilon]", "=", 
     SqrtBox[
      RowBox[{
       FractionBox["r2", 
        RowBox[{"m", "-", 
         RowBox[{"(", 
          RowBox[{"d", "+", "1"}], ")"}]}]], 
       RowBox[{"Diagonal", "[", 
        RowBox[{"Inverse", "[", 
         RowBox[{
          RowBox[{
           RowBox[{"A", "\[HermitianConjugate]"}], ".", "A"}], "//", "N"}], 
         "]"}], "]"}]}]]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"signal", " ", "to", " ", "noise"}], " ", "*)"}], 
    "\[IndentingNewLine]", 
    RowBox[{"\[Gamma]", "=", 
     FractionBox[
      RowBox[{"Last", "[", "c", "]"}], 
      RowBox[{"Last", "[", "\[Epsilon]", "]"}]]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", "function", " ", "*)"}], "\[IndentingNewLine]", 
    RowBox[{"g001", "=", 
     RowBox[{"Plot", "[", 
      RowBox[{
       RowBox[{"f", "[", "\[Theta]", "]"}], ",", 
       RowBox[{"{", 
        RowBox[{"\[Theta]", ",", 
         RowBox[{"-", "\[Pi]"}], ",", "\[Pi]"}], "}"}], ",", 
       "\[IndentingNewLine]", 
       RowBox[{"Frame", "\[Rule]", "True"}], ",", "\[IndentingNewLine]", 
       RowBox[{"FrameTicks", "\[Rule]", "fticks"}], ",", 
       "\[IndentingNewLine]", 
       RowBox[{"PlotStyle", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"Opacity", "[", "0.25", "]"}], ",", "Blue"}], "}"}]}]}], 
      "]"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"bar", " ", "chart"}], " ", "*)"}], "\[IndentingNewLine]", 
    RowBox[{"gbars", "=", 
     RowBox[{"BarChart", "[", 
      RowBox[{"c", ",", "\[IndentingNewLine]", 
       RowBox[{"Frame", "\[Rule]", "True"}], ",", "\[IndentingNewLine]", 
       RowBox[{"PlotLabel", "\[Rule]", 
        RowBox[{
        "\"\<Amplitudes for \!\(\*StyleBox[\"d\",FontSlant->\"Italic\"]\) = \
\>\"", "<>", 
         RowBox[{"ToString", "[", "d", "]"}], "<>", "lf", "<>", 
         "subtitle"}]}], ",", "\[IndentingNewLine]", 
       RowBox[{"ChartStyle", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", "Blue", "}"}], ",", 
          RowBox[{"{", 
           RowBox[{"Opacity", "[", "0.1", "]"}], "}"}]}], "}"}]}], ",", 
       "\[IndentingNewLine]", 
       RowBox[{"FrameTicks", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"Automatic", ",", "Automatic"}], "}"}], ",", 
          RowBox[{"{", 
           RowBox[{
            RowBox[{"Table", "[", "\[IndentingNewLine]", 
             RowBox[{
              RowBox[{"{", 
               RowBox[{
                RowBox[{"k", "+", "1"}], ",", 
                RowBox[{"Subscript", "[", 
                 RowBox[{"\"\<a\>\"", ",", "k"}], "]"}]}], "}"}], 
              "\[IndentingNewLine]", ",", 
              RowBox[{"{", 
               RowBox[{"k", ",", "0", ",", "d"}], "}"}]}], "]"}], ",", 
            "Automatic"}], "}"}]}], "}"}]}], ",", "\[IndentingNewLine]", 
       "ipad", ",", "isize"}], "]"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"compare", " ", "data", " ", "to", " ", "fit"}], " ", "*)"}], 
    "\[IndentingNewLine]", 
    RowBox[{"dsubtitle", "=", 
     RowBox[{"subtitle", "<>", "\"\<, d = \>\"", "<>", 
      RowBox[{"ToString", "[", "d", "]"}]}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"ga", "=", 
     RowBox[{"Show", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{"g001", ",", "g000"}], "}"}], ",", "\[IndentingNewLine]", 
       RowBox[{"PlotLabel", "\[Rule]", 
        RowBox[{"sty", "[", 
         RowBox[{
         "\"\<MoM RCS vs Fourier Cosine Expansion\>\"", "<>", "lf", "<>", 
          "dsubtitle"}], "]"}]}], ",", "\[IndentingNewLine]", 
       RowBox[{"FrameLabel", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"sty", "[", "\"\<Yaw angle, \[Alpha]\>\"", "]"}], ",", 
          RowBox[{
          "sty", "[", 
           "\"\<Mean total RCS, <\!\(\*SubscriptBox[\(\[Sigma]\), \(T\)]\)>\>\
\"", "]"}]}], "}"}]}], ",", "\[IndentingNewLine]", 
       RowBox[{"FrameTicks", "\[Rule]", "fticks"}], ",", 
       "\[IndentingNewLine]", 
       RowBox[{"PlotRange", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{"bot", ",", "top"}], "}"}]}], ",", "\[IndentingNewLine]", 
       "isize", ",", "ipad"}], "]"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"residual", " ", "error"}], " ", "*)"}], "\[IndentingNewLine]", 
    RowBox[{"gb", "=", 
     RowBox[{"ListPlot", "[", 
      RowBox[{"R", ",", "\[IndentingNewLine]", 
       RowBox[{"Frame", "\[Rule]", "True"}], ",", "\[IndentingNewLine]", 
       RowBox[{"FrameTicks", "\[Rule]", "fticks"}], ",", 
       "\[IndentingNewLine]", 
       RowBox[{"FrameLabel", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"sty", "[", "\"\<Yaw angle, \[Alpha]\>\"", "]"}], ",", 
          RowBox[{"sty", "[", "\"\<Residual error\>\"", "]"}]}], "}"}]}], ",",
        "\[IndentingNewLine]", 
       RowBox[{"(*", " ", 
        RowBox[{
         RowBox[{"PlotRange", "\[Rule]", 
          RowBox[{"\[CapitalLambda]", 
           RowBox[{"{", 
            RowBox[{
             RowBox[{"-", "1"}], ",", "1"}], "}"}]}]}], ","}], " ", "*)"}], 
       "\[IndentingNewLine]", 
       RowBox[{"PlotStyle", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{"Red", ",", 
          RowBox[{"PointSize", "[", "0.005", "]"}]}], "}"}]}], ",", 
       "\[IndentingNewLine]", 
       RowBox[{"PlotLabel", "\[Rule]", 
        RowBox[{"sty", "[", 
         RowBox[{
         "\"\<Fourier Approximation Error\>\"", "<>", "lf", "<>", 
          "dsubtitle"}], "]"}]}], ",", "\[IndentingNewLine]", "isize", ",", 
       "ipad"}], "]"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"bar", " ", "chart"}], " ", "*)"}], "\[IndentingNewLine]", 
    RowBox[{"gbars", "=", 
     RowBox[{"BarChart", "[", 
      RowBox[{"c", ",", "\[IndentingNewLine]", 
       RowBox[{"Frame", "\[Rule]", "True"}], ",", "\[IndentingNewLine]", 
       RowBox[{"PlotLabel", "\[Rule]", 
        RowBox[{
        "\"\<Amplitudes for \!\(\*StyleBox[\"d\",FontSlant->\"Italic\"]\) = \
\>\"", "<>", 
         RowBox[{"ToString", "[", "d", "]"}], "<>", "lf", "<>", 
         "subtitle"}]}], ",", "\[IndentingNewLine]", 
       RowBox[{"ChartStyle", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", "Blue", "}"}], ",", 
          RowBox[{"{", 
           RowBox[{"Opacity", "[", "0.1", "]"}], "}"}]}], "}"}]}], ",", 
       "\[IndentingNewLine]", 
       RowBox[{"FrameTicks", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"Automatic", ",", "Automatic"}], "}"}], ",", 
          RowBox[{"{", 
           RowBox[{
            RowBox[{"Table", "[", "\[IndentingNewLine]", 
             RowBox[{
              RowBox[{"{", 
               RowBox[{
                RowBox[{"k", "+", "1"}], ",", 
                RowBox[{"Subscript", "[", 
                 RowBox[{"\"\<a\>\"", ",", "k"}], "]"}]}], "}"}], 
              "\[IndentingNewLine]", ",", 
              RowBox[{"{", 
               RowBox[{"k", ",", "0", ",", "d"}], "}"}]}], "]"}], ",", 
            "Automatic"}], "}"}]}], "}"}]}], ",", "\[IndentingNewLine]", 
       "ipad", ",", "isize"}], "]"}]}], ";", "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"amplitudes", " ", "with", " ", "errors"}], " ", "*)"}], 
    "\[IndentingNewLine]", 
    RowBox[{"ebars", "=", 
     RowBox[{"Table", "[", "\[IndentingNewLine]", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{
         RowBox[{"k", "-", "1"}], ",", 
         RowBox[{"Around", "[", 
          RowBox[{
           RowBox[{"c", "[", 
            RowBox[{"[", "k", "]"}], "]"}], ",", 
           RowBox[{"\[Epsilon]", "[", 
            RowBox[{"[", "k", "]"}], "]"}]}], "]"}]}], "}"}], 
       "\[IndentingNewLine]", ",", 
       RowBox[{"{", 
        RowBox[{"k", ",", 
         RowBox[{"Length", "[", "c", "]"}]}], "}"}]}], "]"}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"gebars", "=", 
     RowBox[{"ListPlot", "[", 
      RowBox[{
      "ebars", ",", "\[IndentingNewLine]", "isize", ",", 
       "\[IndentingNewLine]", 
       RowBox[{"Frame", "\[Rule]", "True"}], ",", "\[IndentingNewLine]", 
       RowBox[{"FrameTicks", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{"Automatic", ",", "Automatic"}], "}"}], ",", 
          RowBox[{"{", 
           RowBox[{
            RowBox[{"Table", "[", 
             RowBox[{
              RowBox[{"{", 
               RowBox[{"k", ",", 
                RowBox[{"Subscript", "[", 
                 RowBox[{
                 "\"\<\!\(\*StyleBox[\"a\",FontSlant->\"Italic\"]\)\>\"", ",",
                   "k"}], "]"}]}], "}"}], ",", 
              RowBox[{"{", 
               RowBox[{"k", ",", "0", ",", 
                RowBox[{"Length", "[", "ebars", "]"}]}], "}"}]}], "]"}], ",", 
            "Automatic"}], "}"}]}], "}"}]}], ",", "\[IndentingNewLine]", 
       RowBox[{"PlotLabel", "\[Rule]", 
        RowBox[{"\"\<Amplitudes with errors for d = \>\"", "<>", 
         RowBox[{"ToString", "[", "d", "]"}], "<>", "lf", "<>", 
         "subtitle"}]}], ",", "\[IndentingNewLine]", 
       RowBox[{"PlotStyle", "\[Rule]", "Blue"}], ",", "\[IndentingNewLine]", 
       RowBox[{"PlotRange", "\[Rule]", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
            RowBox[{"-", "0.5"}], ",", 
            RowBox[{"d", "+", "0.5"}]}], "}"}], ",", "Full"}], "}"}]}], ",", 
       "\[IndentingNewLine]", "isize", ",", "ipad"}], "]"}]}], ";", 
    "\[IndentingNewLine]", 
    RowBox[{"(*", " ", 
     RowBox[{"group", " ", "plots"}], " ", "*)"}], "\[IndentingNewLine]", 
    RowBox[{"gout", "=", 
     RowBox[{"GraphicsGrid", "[", 
      RowBox[{
       RowBox[{"{", 
        RowBox[{
         RowBox[{"{", 
          RowBox[{"ga", ",", "gb"}], "}"}], ",", 
         RowBox[{"{", 
          RowBox[{"gbars", ",", "gebars"}], "}"}]}], "}"}], ",", 
       "\[IndentingNewLine]", 
       RowBox[{"ImageSize", "\[Rule]", 
        RowBox[{"12", " ", "72"}]}]}], "]"}]}]}], "\[IndentingNewLine]", ",", 
   
   RowBox[{"{", 
    RowBox[{"\[Nu]", ",", "3", ",", "30", ",", "1"}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{"d", ",", "0", ",", "25", ",", "1"}], "}"}]}], "]"}]], "Input",
 CellLabel->
  "In[140]:=",ExpressionUUID->"32fd2063-c3e4-431f-80ce-1a45cda14cd0"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`d$$ = 5, $CellContext`\[Nu]$$ = 4, 
    Typeset`show$$ = True, Typeset`bookmarkList$$ = {}, 
    Typeset`bookmarkMode$$ = "Menu", Typeset`animator$$, Typeset`animvar$$ = 
    1, Typeset`name$$ = "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`\[Nu]$$], 3, 30, 1}, {
      Hold[$CellContext`d$$], 0, 25, 1}}, Typeset`size$$ = {
    864., {265., 269.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True, $CellContext`\[Nu]$264624$$ = 
    0, $CellContext`d$264625$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, 
      "Variables" :> {$CellContext`d$$ = 0, $CellContext`\[Nu]$$ = 3}, 
      "ControllerVariables" :> {
        Hold[$CellContext`\[Nu]$$, $CellContext`\[Nu]$264624$$, 0], 
        Hold[$CellContext`d$$, $CellContext`d$264625$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, 
      "Body" :> ($CellContext`meanRCS = 
        Import["rcs-values.dat"]; $CellContext`index = $CellContext`\[Nu]$$ - 
         2; $CellContext`\[Lambda] = 
        Round[$CellContext`\[DoubleStruckC]/($CellContext`\[Nu]$$ 
          1000000)]; $CellContext`rcs = 
        Part[$CellContext`meanRCS, $CellContext`index]; $CellContext`\
\[CapitalTheta] = 
        Table[$CellContext`k (Pi/180), {$CellContext`k, -180, 
           180}]; $CellContext`m = 
        Length[$CellContext`\[CapitalTheta]]; $CellContext`\[Sigma] = 
        RotateLeft[$CellContext`rcs, 180]; $CellContext`mx = 
        Max[$CellContext`\[Sigma]]; $CellContext`mn = 
        Min[$CellContext`\[Sigma]]; $CellContext`\[CapitalLambda] = 
        1.1; {$CellContext`top, $CellContext`bot} = {
         1.1 $CellContext`mx, 0.9 $CellContext`mn}; $CellContext`subtitle = 
        StringJoin["\!\(\*StyleBox[\"\[Nu]\",FontSlant->\"Italic\"]\) = ", 
          ToString[$CellContext`\[Nu]$$], " MHz"]; $CellContext`subtitle = 
        StringJoin[$CellContext`subtitle, 
          ", \!\(\*StyleBox[\"\[Lambda]\",FontSlant->\"Italic\"]\) = ", 
          ToString[$CellContext`\[Lambda]], " m"]; $CellContext`z = 
        Transpose[{$CellContext`\[CapitalTheta], $CellContext`\[Sigma]}]; \
$CellContext`g000 = ListPlot[$CellContext`z, PlotStyle -> {Purple, 
            Opacity[0.5], 
            PointSize[0.005]}]; $CellContext`avector = Table[
          
          Cos[$CellContext`j $CellContext`\[Theta]], {$CellContext`j, 
           0, $CellContext`d$$}]; $CellContext`A = Table[
          Simplify[
           
           ReplaceAll[$CellContext`avector, $CellContext`\[Theta] -> 
            Part[$CellContext`\[CapitalTheta], $CellContext`k]]], \
{$CellContext`k, $CellContext`m}]; $CellContext`c = 
        LeastSquares[$CellContext`A, $CellContext`\[Sigma]]; 
       Clear[$CellContext`f]; $CellContext`f[
          Pattern[$CellContext`\[Theta], 
           Blank[]]] = 
        Dot[$CellContext`c, $CellContext`avector]; $CellContext`F = ReplaceAll[
          $CellContext`f[$CellContext`\[Theta]], $CellContext`\[Theta] -> \
$CellContext`\[CapitalTheta]]; $CellContext`r = $CellContext`\[Sigma] - \
$CellContext`F; $CellContext`R = 
        Transpose[{$CellContext`\[CapitalTheta], $CellContext`r}]; \
$CellContext`r2 = 
        Dot[$CellContext`r, $CellContext`r]; $CellContext`\[Epsilon] = 
        Sqrt[($CellContext`r2/($CellContext`m - ($CellContext`d$$ + 1))) 
          Diagonal[
            Inverse[
             N[
              Dot[
               
               ConjugateTranspose[$CellContext`A], $CellContext`A]]]]]; \
$CellContext`\[Gamma] = 
        Last[$CellContext`c]/Last[$CellContext`\[Epsilon]]; $CellContext`g001 = 
        Plot[
          $CellContext`f[$CellContext`\[Theta]], {$CellContext`\[Theta], -Pi, 
           Pi}, Frame -> True, FrameTicks -> $CellContext`fticks, PlotStyle -> {
            Opacity[0.25], Blue}]; $CellContext`gbars = 
        BarChart[$CellContext`c, Frame -> True, PlotLabel -> 
          StringJoin[
           "Amplitudes for \!\(\*StyleBox[\"d\",FontSlant->\"Italic\"]\) = ", 
            
            
            ToString[$CellContext`d$$], $CellContext`lf, \
$CellContext`subtitle], ChartStyle -> {{Blue}, {
             Opacity[0.1]}}, FrameTicks -> {{Automatic, Automatic}, {
             Table[{$CellContext`k + 1, 
               Subscript["a", $CellContext`k]}, {$CellContext`k, 
               0, $CellContext`d$$}], 
             Automatic}}, $CellContext`ipad, $CellContext`isize]; \
$CellContext`dsubtitle = StringJoin[$CellContext`subtitle, ", d = ", 
          ToString[$CellContext`d$$]]; $CellContext`ga = 
        Show[{$CellContext`g001, $CellContext`g000}, 
          PlotLabel -> $CellContext`sty[
            StringJoin[
            "MoM RCS vs Fourier Cosine Expansion", $CellContext`lf, \
$CellContext`dsubtitle]], FrameLabel -> {
            $CellContext`sty["Yaw angle, \[Alpha]"], 
            $CellContext`sty[
            "Mean total RCS, <\!\(\*SubscriptBox[\(\[Sigma]\), \(T\)]\)>"]}, 
          FrameTicks -> $CellContext`fticks, 
          PlotRange -> {$CellContext`bot, $CellContext`top}, \
$CellContext`isize, $CellContext`ipad]; $CellContext`gb = 
        ListPlot[$CellContext`R, Frame -> True, 
          FrameTicks -> $CellContext`fticks, FrameLabel -> {
            $CellContext`sty["Yaw angle, \[Alpha]"], 
            $CellContext`sty["Residual error"]}, PlotStyle -> {Red, 
            PointSize[0.005]}, PlotLabel -> $CellContext`sty[
            StringJoin[
            "Fourier Approximation Error", $CellContext`lf, \
$CellContext`dsubtitle]], $CellContext`isize, $CellContext`ipad]; \
$CellContext`gbars = 
        BarChart[$CellContext`c, Frame -> True, PlotLabel -> 
          StringJoin[
           "Amplitudes for \!\(\*StyleBox[\"d\",FontSlant->\"Italic\"]\) = ", 
            
            
            ToString[$CellContext`d$$], $CellContext`lf, \
$CellContext`subtitle], ChartStyle -> {{Blue}, {
             Opacity[0.1]}}, FrameTicks -> {{Automatic, Automatic}, {
             Table[{$CellContext`k + 1, 
               Subscript["a", $CellContext`k]}, {$CellContext`k, 
               0, $CellContext`d$$}], 
             Automatic}}, $CellContext`ipad, $CellContext`isize]; \
$CellContext`ebars = Table[{$CellContext`k - 1, 
           Around[
            Part[$CellContext`c, $CellContext`k], 
            Part[$CellContext`\[Epsilon], $CellContext`k]]}, {$CellContext`k, 
           
           Length[$CellContext`c]}]; $CellContext`gebars = 
        ListPlot[$CellContext`ebars, $CellContext`isize, Frame -> True, 
          FrameTicks -> {{Automatic, Automatic}, {
             Table[{$CellContext`k, 
               Subscript[
               "\!\(\*StyleBox[\"a\",FontSlant->\"Italic\"]\)", \
$CellContext`k]}, {$CellContext`k, 0, 
               Length[$CellContext`ebars]}], Automatic}}, PlotLabel -> 
          StringJoin["Amplitudes with errors for d = ", 
            
            ToString[$CellContext`d$$], $CellContext`lf, \
$CellContext`subtitle], PlotStyle -> Blue, 
          PlotRange -> {{-0.5, $CellContext`d$$ + 0.5}, 
            Full}, $CellContext`isize, $CellContext`ipad]; $CellContext`gout = 
        GraphicsGrid[{{$CellContext`ga, $CellContext`gb}, \
{$CellContext`gbars, $CellContext`gebars}}, ImageSize -> 12 72]), 
      "Specifications" :> {{$CellContext`\[Nu]$$, 3, 30, 
         1}, {$CellContext`d$$, 0, 25, 1}}, "Options" :> {}, 
      "DefaultOptions" :> {}],
     ImageSizeCache->{909., {351., 357.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UndoTrackedVariables:>{Typeset`show$$, Typeset`bookmarkMode$$},
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Manipulate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{
  3.79417274931957*^9, {3.794173107633059*^9, 3.794173109400476*^9}},
 CellLabel->
  "Out[140]=",ExpressionUUID->"270293d4-4645-4212-b8cd-e7c8fd24755e"]
}, Open  ]]
},
WindowSize->{1257, 753},
WindowMargins->{{Automatic, 198}, {Automatic, 6}},
FrontEndVersion->"12.0 for Mac OS X x86 (64-bit) (April 8, 2019)",
StyleDefinitions->"Default.nb"
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{}
*)
(*CellTagsIndex
CellTagsIndex->{}
*)
(*NotebookFileOutline
Notebook[{
Cell[CellGroupData[{
Cell[1510, 35, 16694, 412, 2294, "Input",ExpressionUUID->"32fd2063-c3e4-431f-80ce-1a45cda14cd0"],
Cell[18207, 449, 8257, 163, 785, "Output",ExpressionUUID->"270293d4-4645-4212-b8cd-e7c8fd24755e"]
}, Open  ]]
}
]
*)

(* NotebookSignature DwTdUbyOUC#bsBK4n9pWMHMB *)
