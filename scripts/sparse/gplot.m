## Copyright (C) 2005 Ivana Varekova
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
## 02110-1301  USA

## -*- texinfo -*-
## @deftypefn {Function File} {} gplot (@var{a}, @var{xy})
## @deftypefnx {Function File} {} gplot (@var{a}, @var{xy}, @var{line_style})
## @deftypefnx {Function File} {[@var{x}, @var{y}] =} gplot (@var{a}, @var{xy})
## Plot a graph defined by @var{A} and @var{xy} in the graph theory
## sense.  @var{A} is the adjacency matrix of the array to be plotted
## and @var{xy} is an @var{n}-by-2 matrix containing the coordinates of
## the nodes of the graph.
##
## The optional parameter @var{line_style} defines the output style for
## the plot.  Called with no output arguments the graph is plotted
## directly.  Otherwise, return the coordinates of the plot in @var{x}
## and @var{y}.
## @seealso{treeplot, etreeplot, spy}
## @end deftypefn

function [x, y] = gplot (A, xy, line_style)

  if (nargin < 2 || nargin > 3 || nargout > 2)
    print_usage ();
  endif

  if (nargin == 2)
    line_style = "1;;";
  endif

  [i, j] = find (A);
  xcoord = [xy(i,1), xy(j,1), NaN * ones(length(i),1)]'(:);
  ycoord = [xy(i,2), xy(j,2), NaN * ones(length(i),1)]'(:);

  if (nargout == 0)
    plot (xcoord, ycoord, line_style); 
  else
    x = xcoord;
    y = ycoord;
  endif

endfunction
