function result = stencil(lattice)
% Function M-File: stencil(L)
% 
% Description: The function takes as argument a matrix representing a
% system lattice of J. Conway's Game of Life. Each element of the matrix
% should have values either zero or one, although variations are possible
% and different inputs are accepted.
% For simplicity only square matrices are allowed, if this requirement is
% not satisfied the function will output an error message.
% 
%     Input:        lattice,    square matrix representing system lattice
%                               of Conways's Game of Life, each element of
%                               the matrix should have values either zero
%                               or one.
% 
%     Output:       result,     output matrix where each element is
%                               the sum of its neighbours in the initial
%                               input matrix
%
% Author:       Enrico Caprioglio, CID: 01336218
% Date:         18/03/2021

% get lattice sizes, Lx = number of columns, Ly = number of rows 
[Ly,Lx] = size(lattice);
% for simplicity we only work with square lattices
% output error if lattice is not a square matrix
if Lx == Ly
else error('Lattice needs to be a square lattice')
end
L = Lx; % sice Lx = Ly = L

% Define two arrays that are used to shift negatively or positively the
% index in the lattice. These are used to sum the values of the neighborus
% at each point 
ne_shift = mod((1:L)-2,L)+1;  % this shifts the index negatively
po_shift = mod((1:L),L)+1;    % this shifts the index positively

% sum all neighbour parameters together
% this method is similar to that shown in:
% https://www.mathworks.com/content/dam/mathworks/mathworks-dot-com/moler/exm/chapters/life.pdf
result = lattice(ne_shift,ne_shift) + lattice(:,ne_shift) ...
    + lattice(ne_shift,:) + lattice(po_shift,ne_shift) ...
    + lattice(:,:) + lattice(po_shift,:) + lattice(:,po_shift) ...
    + lattice(ne_shift,po_shift) + lattice(po_shift,po_shift);

end