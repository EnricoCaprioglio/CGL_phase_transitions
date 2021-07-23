%% Conway's Game of Life (CGL) simulation
% File name: CGL_simulation.m
% 
% Description: In this script file we implement a simple algorithm
% to simulate J. Conway's Game of Life. Standard parameters for birth rule
% and survival rule are initialised as default, i.e. no user input for these.
% User input is required for lattice size L, occupation probability p and
% to determine the number of timesteps for the simulation.
% To run this code it is required to have in the same folder an M-file with
% the function stencil.m. This function simply creates a matrix where each
% element takes the value of the total Von Neumann neighbourhood of the
% corresponding element in the input matrix. More information can be found
% in the function description.
% 
%     Input:        L,          lattice size LxL (10 < L < 500 is suggested)
%                   p,          occupation probability, p needs to be
%                               greater than 0 and smaller than 1
%                   final_t,    number of timesteps for the simulation
%                               100 only lasts for a few seconds
%                               1000 lasts for about a minute
% 
%     Output:       figure(1),  Game of Life animation
% 
% Version 1.0    Main code for GOL, commented           18 March 2021
% Version 1.1    Added description and comments         20 March 2021
% Version 1.1    Added user inputs, commented           23 March 2021

% 
% Written by Caprioglio Enrico, CID: 01336218

% The following is to clear the workspace and close previous figures
clear
close all
clc

%% Main code for GOL simple simulation.
% Initialise simulation parameters:
% user input size of the lattice grid L
% for this simulation L < 500 is suggested
prompt1 = 'Please, enter the value L of the desired lattice grid LxL >> ';
prompt2 = 'L < 500 is suggested, do you wish to continue? 0 for yes, 1 for no >> ';
prompt3 = 'Please, enter the value L of the desired lattice grid LxL, you will not be asked this again >> ';
prompt4 = 'L needs to be an integer greater than zero, suggested values are 10 < L < 500 \nPlease reinsert the value of L >> ';
L = input(prompt1);           % user input for lattice grid L
loop_check = 0;               % variable to exit loop
while L < 0 | mod(L,1) ~= 0   % require L integer > 0
    L = input(prompt4);
end
if L > 500                    % warn L is quite big
    while loop_check == 0
        check = input(prompt2);
        if check == 0         % continue
            loop_check = 1;   % Exit the loop
        elseif check == 1     % ask L one more time
            L = input(prompt3);
            loop_check = 1;   % Exit the loop
        else
            loop_check = 0;   % Stay in the loop
        end
    end
end

% user input occupation probability p
prompt1 = 'Please, enter the value for the occupation probability p between 0 and 1: \n(p = 0.5 is suggested) >> ';
prompt2 = 'Please, the occupation probability p is a probability so it needs to be between 0 and 1. \nRetry here >> ';
p = input(prompt1);       % user input for interval's upper limit
while p > 1 || p < 0      % do not accept a > 1 or a < 0
     p = input(prompt2);
end

% the following is a quick way to create a matrix of
% ones and zeros with probability p and 1-p respectively
temp_parameter = 1 + p;                     % a temporary parameter between 1 and 2
lattice = ceil(rand(L,L)*temp_parameter)-1; % creates LxL matrix of zeros and ones
% birth rule: a cell in state 0 becomes 1 iff s \in [B_l,B_h]
B_l = 3; B_h = B_l;
% survival rule: a cell in state 1 remains 1 iff s \in [S_l,S_h]
S_l = 2; S_h = 3;

% user input number of timesteps
prompt1 = 'Please, enter the number of timesteps for the simulation \n100 timesteps only lasts a few seconds, 1000 lasts about a minute >> ';
prompt2 = 'More than 1000 timesteps might results in a long simulation, are you sure about this? 0 for Yes, 1 for No >> ';
prompt3 = 'Re-enter the number of timesteps for the simulation, suggested values are between 200 and 1000, \nYou will not be asked this again >> ';
prompt4 = 'The number of timesteps needs to be greater than zero, suggested values are between 200 and 1000 \nPlease reinsert the number of timesteps >> ';
final_t = input(prompt1);       % user input for interval's upper limit
while final_t < 0
    final_t = input(prompt4);
end
loop_check = 0;
if final_t > 1000               % warn long simulation
     check = input(prompt2);
     while loop_check == 0
         if check               % if answered no
             final_t = input(prompt3);
             while final_t < 0  % check final_t > 0 again
                final_t = input(prompt4);
             end
             loop_check = 1;    % exit the while loop
         elseif check == 0      % if answered yes
             loop_check = 1;    % exit the while loop
         else
             loop_check = 0;    % stay in the while loop
             check = 1;         % re ask number of timesteps
         end
     end
end
% end of user inputs

% start of the simulation
for i = 1:final_t
    % compute neighbour sum using the stencil function (see stencil.m M-file) 
    neigh_sum = stencil(lattice);
    lattice = (neigh_sum==B_l) + (neigh_sum==S_h+1).*lattice; % update rule (see report for full explanation)  
    % show figure
    imagesc(lattice);
    axis equal;
    axis off;
    drawnow;
end
