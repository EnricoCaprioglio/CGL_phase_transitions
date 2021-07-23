function result = async_update(lattice, a, B_l, S_h)
% Function M-File: async_update(lattice, a, B_l, S_h)
% 
% Description: This function adds the asynchronous element to J.Conway's 
% Game of Life. Each element of the lattice matrix gets assigned a
% random number, if this probability is lower than the asynchronous
% parameter a the cell will get updated. Otherwise the cell will be
% left unchanged. The birth and death parameters (B_l, S_h) are standard 
% parameters used in the original rules of CGL. Variations are possible 
% but B_l = 3 and S_h = 3 are suggested.
% 
% Note, in order for this function to work it is required to have stencil.m
% function M-file stored in the same directory as this M-file. Otherwise,
% please add the necessary paths.
% 
%     Input:        lattice,    square matrix representing system lattice
%                               of Conways's Game of Life, each element of
%                               the matrix should have values either zero
%                               or one.
%                   a,          asynchronous parameter
%                   B_l,        birth parameter
%                   S_h,        death parameter
% 
%     Output:       result,     asynchronously updated lattice
%
% Author:       Enrico Caprioglio, CID: 01336218
% Date:         19/03/2021

% get lattice sizes, Lx is the number of columns
% Ly is the number of rows 
[Ly,Lx] = size(lattice);
% for simplicity we only work with square lattices
% output error if lattice is not a square matrix
if Lx == Ly
else error('Lattice needs to be a square lattice')
end
L = Lx; % sice Lx = Ly = L

result = lattice;             % copy initial lattice
neigh_sum = stencil(lattice); % get matrix f neighbour values (see stencil.m description)
temp_lattice = (neigh_sum==B_l) + (neigh_sum==S_h+1).*lattice; % update rule
a_matrix = rand(L,L) < a;     % matrix that selects cells to update

% iterate through the lattice and update only the cells of the result matrix
% that correspond to cells with value 1 in a_matrix.
for row_index  = 1:L
    for col_index= 1:L
        if a_matrix(row_index, col_index)   % if value == 1 (logical True)
            result(row_index, col_index) = temp_lattice(row_index, col_index);
        end
    end
end

end