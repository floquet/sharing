(* ::Package:: *)

(* ::Input::Initialization:: *)
BeginPackage["foo`"]
Unprotect@@Names["foo`*"];
ClearAll@@Names["foo`*"];

f::usage="f[x]"
Begin["`Private`"]

f[x_]:=Module[{},x^2];

End[]
Protect@@Names["foo`*"];
EndPackage[]
