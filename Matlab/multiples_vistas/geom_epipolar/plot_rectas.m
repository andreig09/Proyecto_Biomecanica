function plot_rectas(lx, varargin )
%Funcion que permite plotear un conjunto de rectas en un plano

%% ENTRADA
%lx --> es una matriz cuyas columnas son los coeficientes de la recta en coordenadas homogeneas
%       ax+by+c= se guarda como lx=(a;b;c)

%% EJEMPLOS
% figure; hold on; axis equal;
% axis([-100 100 -100 100]);
% plot_rectas(lx, 'Color', 'm', 'LineWidth', 2); 

%% CUERPO DE LA FUNCION

%Para tener los parametros que necesita la funcion drawLine() se debe pasar de la notacion lx=(a;b;c) a lx=(-c/a ; 0; -b/a; 1)
a = lx(1,:);
b = lx(2,:);
c = lx(3,:);
n = length(a);
lx = [-c./a;...
      zeros(1,n);...
      -b./a; ...
      ones(1, n)...
      ];     
drawLine(lx', varargin{:})       
end


function varargout = drawLine(lin, varargin)
%DRAWLINE Draw a straight line clipped by the current axis
%
%   drawLine(LINE);
%   Draws the line LINE on the current axis, by using current axis to clip
%   the line. 
%
%   drawLine(LINE, PARAM, VALUE);
%   Specifies drawing options.
%
%   H = drawLine(...)
%   Returns a handle to the created line object. If clipped line is not
%   contained in the axis, the function returns -1.
%   
%   Example
%     figure; hold on; axis equal;
%     axis([0 100 0 100]);
%     drawLine([30 40 10 20]);
%     drawLine([30 40 20 -10], 'Color', 'm', 'LineWidth', 2);
%     drawLine([-30 140 10 20]);
%
%   See also:
%   lines2d, createLine, drawEdge
%
%   ---------
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 31/10/2003.
%

%   HISTORY
%   25/05/2004 add support for multiple lines (loop)
%   23/05/2005 add support for arguments
%   03/08/2010 bug for lines outside box (thanks to Reto Zingg)
%   04/08/2010 rewrite using clipLine
%   2011-10-11 add management of axes handle

% extract handle of axis to draw in
if isAxisHandle(lin)
    ax = lin;
    lin = varargin{1};
    varargin(1) = [];
else
    ax = gca;
end

% default style for drawing lines
if length(varargin) ~= 1
    varargin = [{'color', 'b'}, varargin];
end

% extract bounding box of the current axis
xlim = get(ax, 'xlim');
ylim = get(ax, 'ylim');

% clip lines with current axis box
clip = clipLine(lin, [xlim ylim]);
ok   = isfinite(clip(:,1));

% initialize result array to invalide handles
h = -1 * ones(size(lin, 1), 1);

% draw valid lines
h(ok) = plot(ax, clip(ok, [1 3])', clip(ok, [2 4])', varargin{:});

% return line handle if needed
if nargout > 0
    varargout = {h};
end
end

function b = isAxisHandle(arg)
%ISAXISHANDLE Check if the input corresponds to a valid axis hanfle
%
%   B = isAxisHandle(VAR)
%   If the value of VAR is scalar, corresponds to a valid matlab handle,
%   and has type equal to 'axis', then returns TRUE. Otherwise, returns
%   false.
%   This function is used to check if first argument of drawing functions
%   corresponds to data or to axis handle to draw in.
%
%   Example
%     isAxisHandle(gca)
%     ans =
%         1
%
%   See also
%   drawPoint, drawLine, drawEdge
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-09-21,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

b = isscalar(arg) && ishandle(arg) && strcmp(get(arg, 'type'), 'axes');
end


function edge = clipLine(line, box, varargin)
%CLIPLINE Clip a line with a box
%
%   EDGE = clipLine(LINE, BOX);
%   LINE is a straight line given as a 4 element row vector: [x0 y0 dx dy],
%   with (x0 y0) being a point of the line and (dx dy) a direction vector,
%   BOX is the clipping box, given by its extreme coordinates: 
%   [xmin xmax ymin ymax].
%   The result is given as an edge, defined by the coordinates of its 2
%   extreme points: [x1 y1 x2 y2].
%   If line does not intersect the box, [NaN NaN NaN NaN] is returned.
%   
%   Function works also if LINE is a Nx4 array, if BOX is a Nx4 array, or
%   if both LINE and BOX are Nx4 arrays. In these cases, EDGE is a Nx4
%   array.
%   
%
%   Example
%   line = [30 40 10 0];
%   box = [0 100 0 100];
%   res = clipLine(line, box)
%   res = 
%       0 40 100 40
%
%   See also:
%   lines2d, boxes2d, edges2d
%   clipEdge, clipRay
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2007-08-27,    using Matlab 7.4.0.287 (R2007a)
% Copyright 2010 INRA - Cepia Software Platform.

% HISTORY
% 2010-05-16 rewrite using intersectLines, add precision management
% 2010-08-03 fix bugs (thanks to Reto Zingg)
% 2010-08-06 remove management of EPS by checking edge midpoint (thanks
%   again to Reto Zingg)

% adjust size of two input arguments
nLines = size(line, 1);
nBoxes = size(box, 1);
if nLines == 1 && nBoxes > 1
    line = repmat(line, nBoxes, 1);
elseif nBoxes == 1 && nLines > 1
    box = repmat(box, nLines, 1);
elseif nLines ~= nBoxes
    error('bad sizes for input');
end

% allocate memory
nLines = size(line, 1);
edge   = zeros(nLines, 4);

% main loop on lines
for i = 1:nLines
    % extract limits of the box
    xmin = box(i, 1);
    xmax = box(i, 2);
    ymin = box(i, 3);
    ymax = box(i, 4);
    
    % use direction vector for box edges similar to direction vector of the
    % line in order to reduce computation errors
    delta = hypot(line(i,3), line(i,4));
    
	% compute intersection with each edge of the box
    px1 = intersectLines(line(i,:), [xmin ymin delta 0]);   % lower edge
    px2 = intersectLines(line(i,:), [xmax ymin 0 delta]);   % right edge
    py1 = intersectLines(line(i,:), [xmax ymax -delta 0]);  % upper edge
    py2 = intersectLines(line(i,:), [xmin ymax 0 -delta]);  % left edge
    
    % remove undefined intersections (case of lines parallel to box edges)
    points = [px1 ; px2 ; py1 ; py2];
    points = points(isfinite(points(:,1)), :);
	
    % sort points according to their position on the line
    pos = linePosition(points, line(i,:));
    [pos inds] = sort(pos); %#ok<ASGLU>
    points = points(inds, :);
    
    % create clipped edge by using the two points in the middle
    ind = size(points, 1)/2;
    inter1 = points(ind,:);
    inter2 = points(ind+1,:);
    edge(i, 1:4) = [inter1 inter2];
    
    % check that middle point of the edge is contained in the box
    midX = mean(edge(i, [1 3]));
    xOk = xmin <= midX && midX <= xmax;
    midY = mean(edge(i, [2 4]));
    yOk = ymin <= midY && midY <= ymax;
    
    % if one of the bounding condition is not met, set edge to NaN
    if ~(xOk && yOk)
        edge (i,:) = NaN;
    end
end
end

function point = intersectLines(line1, line2, varargin)
%INTERSECTLINES Return all intersection points of N lines in 2D
%
%   PT = intersectLines(L1, L2);
%   returns the intersection point of lines L1 and L2. L1 and L2 are 1-by-4
%   row arrays, containing parametric representation of each line (in the
%   form [x0 y0 dx dy], see 'createLine' for details).
%   
%   In case of colinear lines, returns [Inf Inf].
%   In case of parallel but not colinear lines, returns [NaN NaN].
%
%   If each input is [N*4] array, the result is a [N*2] array containing
%   intersections of each couple of lines.
%   If one of the input has N rows and the other 1 row, the result is a
%   [N*2] array.
%
%   PT = intersectLines(L1, L2, EPS);
%   Specifies the tolerance for detecting parallel lines. Default is 1e-14.
%
%   Example
%   line1 = createLine([0 0], [10 10]);
%   line2 = createLine([0 10], [10 0]);
%   point = intersectLines(line1, line2)
%   point = 
%       5   5
%
%   See also
%   lines2d, edges2d, intersectEdges, intersectLineEdge
%   intersectLineCircle
%
%   ---------
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 31/10/2003.
%

%   HISTORY
%   2004-02-19 add support for multiple lines.
%   2007-03-08 update doc
%   2011-10-07 code cleanup


%% Process input arguments

% extract tolerance
tol = 1e-14;
if ~isempty(varargin)
    tol = varargin{1};
end

% check size of each input
N1 = size(line1, 1);
N2 = size(line2, 1);
N = max(N1, N2);
if N1 ~= N2 && N1*N2 ~= N
    error('matGeom:IntersectLines:IllegalArgument', ...
        'The two input arguments must have same number of lines');
end


%% Check parallel and colinear lines

% coordinate differences of origin points
dx = bsxfun(@minus, line2(:,1), line1(:,1));
dy = bsxfun(@minus, line2(:,2), line1(:,2));

% indices of parallel lines
denom = line1(:,3) .* line2(:,4) - line2(:,3) .* line1(:,4);
par = abs(denom) < tol;

% indices of colinear lines
col = abs(dx .* line1(:,4) - dy .* line1(:,3)) < tol & par ;

% initialize result array
x0 = zeros(N, 1);
y0 = zeros(N, 1);

% initialize result for parallel lines
x0(col) = Inf;
y0(col) = Inf;
x0(par & ~col) = NaN;
y0(par & ~col) = NaN;

% in case all line couples are parallel, return
if all(par)
    point = [x0 y0];
    return;
end


%% Extract coordinates of itnersecting lines

% indices of intersecting lines
inds = ~par;

% extract base coordinates of first lines
if N1 > 1
    line1 = line1(inds,:);
end
x1 =  line1(:,1);
y1 =  line1(:,2);
dx1 = line1(:,3);
dy1 = line1(:,4);

% extract base coordinates of second lines
if N2 > 1
    line2 = line2(inds,:);
end
x2 =  line2(:,1);
y2 =  line2(:,2);
dx2 = line2(:,3);
dy2 = line2(:,4);

% re-compute coordinate differences of origin points
dx = bsxfun(@minus, line2(:,1), line1(:,1));
dy = bsxfun(@minus, line2(:,2), line1(:,2));


%% Compute intersection points

denom = denom(inds);
x0(inds) = (x2 .* dy2 .* dx1 - dy .* dx1 .* dx2 - x1 .* dy1 .* dx2) ./ denom ;
y0(inds) = (dx .* dy1 .* dy2 + y1 .* dx1 .* dy2 - y2 .* dx2 .* dy1) ./ denom ;

% concatenate result
point = [x0 y0];
end


function pos = linePosition(point, line, varargin)
%LINEPOSITION Position of a point on a line
%
%   POS = linePosition(POINT, LINE);
%   Computes position of point POINT on the line LINE, relative to origin
%   point and direction vector of the line.
%   LINE has the form [x0 y0 dx dy],
%   POINT has the form [x y], and is assumed to belong to line.
%
%   POS = linePosition(POINT, LINES);
%   If LINES is an array of NL lines, return NL positions, corresponding to
%   each line.
%
%   POS = linePosition(POINTS, LINE);
%   If POINTS is an array of NP points, return NP positions, corresponding
%   to each point.
%
%   POS = linePosition(POINTS, LINES);
%   If POINTS is an array of NP points and LINES is an array of NL lines,
%   return an array of [NP NL] position, corresponding to each couple
%   point-line.
%
%   POS = linePosition(POINTS, LINES, 'diag');
%   When POINTS and LINES have the same number of rows, computes positions
%   only for couples POINTS(i,:) and LINES(i,:). The result POS is a column
%   vector with as many rows as the number of points/lines.
%
%
%   Example
%   line = createLine([10 30], [30 90]);
%   linePosition([20 60], line)
%   ans =
%       .5
%
%   See also:
%   lines2d, createLine, projPointOnLine, isPointOnLine
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 25/05/2004.
%

%   HISTORY
%   2005-07-07 manage multiple input
%   2011-06-15 avoid the use of repmat when possible
%   2012-10-24 rewrite using bsxfun
%   2012-11-22 add support for the diag option


if ~isempty(varargin) && ischar(varargin{1}) && strcmpi(varargin{1}, 'diag')
    % In the case of 'diag' option, use direct correspondence between
    % points and lines
    
    % check input have same size
    np = size(point, 1);
    nl = size(line, 1);
    if np ~= nl
        error('matGeom:linePosition', ...
            'Using diag option, number of points and lines should be the same');
    end
    
    % direction vector of the lines
    vx = line(:, 3);
    vy = line(:, 4);
    
    % difference of coordinates between point and line origins
    dx = point(:, 1) - line(:, 1);
    dy = point(:, 2) - line(:, 2);
    
else
    % General case -> return NP-by-NL array
    
    % direction vector of the lines
    vx = line(:, 3)';
    vy = line(:, 4)';
    
    % difference of coordinates between point and line origins
    dx = bsxfun(@minus, point(:, 1), line(:, 1)');
    dy = bsxfun(@minus, point(:, 2), line(:, 2)');

end

% squared norm of direction vector, with a check of validity 
delta = vx .* vx + vy .* vy;
invalidLine = delta < eps;
delta(invalidLine) = 1; 

% compute position of points projected on the line, by using normalised dot
% product (NP-by-NE array) 
pos = bsxfun(@rdivide, bsxfun(@times, dx, vx) + bsxfun(@times, dy, vy), delta);

% ensure degenerated edges are correclty processed (consider the first
% vertex is the closest)
pos(:, invalidLine) = 0;
end
