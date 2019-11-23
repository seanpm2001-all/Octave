## Copyright (C) 2019 Markus Meisinger
##
## This file is part of Octave.
##
## Octave is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn  {} {@var{xy} =} stream2 (@var{x}, @var{y}, @var{u}, @var{v}, @var{sx}, @var{sy})
## @deftypefnx {} {@var{xy} =} stream2 (@var{u}, @var{v}, @var{sx}, @var{sy})
## @deftypefnx {} {@var{xy} =} stream2 (@dots{}, "@var{options}")
## Compute 2D streamline data.
##
## Calculates streamlines of a vector field given by [@var{u}, @var{v}].
## The vector field is defined over a rectangular grid given by
## [@var{x}, @var{y}]. The streamlines start at the seed points
## [@var{sx}, @var{sy}]. The returned value @var{xy} contains a cell array
## of vertex arrays. If the starting point is outside the vector field,
## [] is returned.
##
## The input parameter @var{options} is a 2D vector of the form
## [@var{stepsize}, @var{maxnumbervertices}]. The first parameter specifies
## the step size used for trajectory integration (default 0.1). It is
## allowed to set a negative value to control the direction of integration.
## The second parameter specifies the maximum number of segments used to
## create a streamline (default 10000).
##
## The return value @var{xy} is a @nospell{nverts x 2} matrix containing the
## coordinates of the field line segments.
##
## Example:
##
## @example
## @group
## [x, y] = meshgrid (0:3);
## u = 2 * x;
## v = y;
## xy = stream2 (x, y, u, v, 1.0, 0.5);
## @end group
## @end example
##
## @seealso{streamline, stream3}
##
## @end deftypefn

## References:
##
## @article{
##    title = {Particle Tracing Algorithms for 3D Curvilinear Grids},
##    year = {2000},
##    author = {Nielson, Gregory and Uller, H. and Sadarjoen, I. and Walsum, Theo and Hin, Andrea and Post, Frits}
## }
##
## @article{
##    title = {Sources of error in the graphical analysis of CFD results},
##    publisher = {Journal of Scientific Computing},
##    year = {1988},
##    volume = {3},
##    number = {2},
##    pages = {149--164},
##    author = {Buning, Pieter G.},
## }

function xy = stream2 (varargin)

  options = [];
  switch (length (varargin))
    case (0)
      print_usage ();
    case {4,5}
      if (length (varargin) == 4)
        [u, v, spx, spy] = varargin{:};
      else
        [u, v, spx, spy, options] = varargin{:};
      endif
      [m, n] = size (u);
      [x, y] = meshgrid (1:n, 1:m);
    case (6)
      [x, y, u, v, spx, spy] = varargin{:};
    case (7)
      [x, y, u, v, spx, spy, options] = varargin{:};
    otherwise
      error ("stream2: unknown input parameter count");
  endswitch

  h = 0.1;
  maxnverts = 10000;
  if (! isempty (options))
    switch (length (options))
      case (1)
        h = options(1);
      case (2)
        h = options(1);
        maxnverts = options(2);
      otherwise
        error ("stream2: wrong options length");
    endswitch
  endif

  if ((! isnumeric (h)) || (h == 0))
    error ("stream2: step size error");
  endif
  if ((! isnumeric (maxnverts)) || (maxnverts < 1))
    error ("stream2: max num vertices error");
  endif
  if (! (isequal (size (u), size (v), size (x), size (y)) && ...
         isequal (size (spx), size (spy))) )
    error ("stream2: matrix dimensions must match");
  endif
  if (iscomplex (u) || iscomplex (v) || iscomplex (x) || ...
      iscomplex (y) || iscomplex (spx) || iscomplex (spy))
    error ("stream2: input must be real valued");
  endif

  gx = x(1,:);
  gy = y(:,1).';

  ## Jacobian Matrix
  dx = diff (gx);
  dy = diff (gy);
  ## "<" used to check if the mesh is ascending
  if (any (dx <= 0) || any (dy <= 0) || ...
      any (isnan (dx)) || any (isnan (dy)))
    error ("stream2: ill shaped elements in mesh");
  endif
  tx = 1./dx;
  ty = 1./dy;
  ## "Don't cares" used for handling points located on the border
  tx(end + 1) = 0;
  ty(end + 1) = 0;
  dx(end + 1) = 0;
  dy(end + 1) = 0;

  px = spx(:);
  py = spy(:);

  for nseed = 1:length (px)

    xp = px(nseed);
    yp = py(nseed);
    idx = find (logical (diff (gx <= xp)), 1);
    if (gx(end) == xp)
      idx = numel (gx);
    endif
    idy = find (logical (diff (gy <= yp)), 1);
    if (gy(end) == yp)
      idy = numel (gy);
    endif

    if (isempty (idx) || isempty (idy))
      xy{nseed} = [];
    else
      ## Transform seed from P coordinates to C coordinates
      zeta = (idx - 1) + (xp - gx(idx)) * tx(idx);
      xi = (idy - 1) + (yp - gy(idy)) * ty(idy);

      C = streameuler2d (u, v, tx, ty, zeta, xi, h, maxnverts);

      ## Transform from C coordinates to P coordinates
      idu = floor (C(:,1));
      idv = floor (C(:,2));
      xy{nseed} = [gx(idu + 1).' + (C(:,1) - idu).*(dx(idu + 1).'), ...
                   gy(idv + 1).' + (C(:,2) - idv).*(dy(idv + 1).')];
    endif

  endfor

endfunction

%!demo
%! clf;
%! [x, y] = meshgrid (-5:5, -4:4);
%! u = x - 2 * y;
%! v = 2 * x - 3 * y;
%! sx = [3, 0, -1, -2, -3, 0, 1, 2];
%! sy = [3, 3, 3, 3, -3, -3, -3, -3];
%! h = streamline (x, y, u, v, sx, sy, 0.05);
%! set (h, "color", "r");
%! hold on;
%! quiver (x, y, u, v);
%! scatter (sx(:), sy(:), 20, "filled", "o", "markerfacecolor", "r");
%! grid on;
%! title ("Asymptotically Stable Equilibrium");
%! axis equal;

%!test
%! xy = stream2([1,1,1;2,2,2;3,3,3], [1,1,1;2,2,2;3,3,3], 1, 1, [0.01,5]);
%! assert (numel (xy{:}), 10);
