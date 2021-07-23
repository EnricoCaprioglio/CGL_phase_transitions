%% Conway's Game of Life (CGL) asynchronous simulation
% File name: CGL_async_simulation.m
% 
% Description: In this script file we perform an asynchronous simulation of
% the famous Conway's Game of Life. The asynchronous parameter a determines
% the probability that a cell gets updated at each timestep in the
% simulation. To quantify the system's structural perturbation we use a 
% density measure rho = (number of living cells)/(total number of cells).
% To run this code it is required to have in the same folder an M-file with
% the function stencil.m and async_update.m. The first function simply creates
% a matrix where each element takes the value of the total Von Neumann 
% neighbourhood of the corrisponding element in the input matrix.
% More information can be found in the stencil.m function description.
% async_update.m updates the input lattice matrix according to the normal 
% rules of CGL but asynchronously. See more information in the function
% file description.
% 
% The script is divided into two cells:
% 1. Asynchronous Implementation single asynchronous parameter a
% 2. Asynchronous simulation for a range of asynchronous parameters a_arr
% 
% Cell 1: 
% 
%     Input:        L,          lattice size LxL
%                   p,          occupation probability
%                   a,          asynchronous parameter 
% 
%     Output:       figure(1)   simulation in the steady state of the  
%                               perturbed CGL for 1000 timesteps.
%                               NB. number of timesteps is fixed.
%                   density,    by means of fprintf
% 
% Cell 2:
% 
%     Input:        no user input required
% 
%     Output:       figure(1)   plot of density for a range of parameters a
%                   
% In cell 2, it's suggsted not to change default parameters, changing them 
% might alter the results of the simulation reported in the Mini-project 
% report and the phase transition might not appear in the final plot.
% 
% Written by Caprioglio Enrico, CID: 01336218
% 
% Version 1.0    Asynchronous Implementation            19 March 2021
% Version 1.1    First asynchronous test, commented     20 March 2021
% Version 1.2    Full asynchronous test, commented      21 March 2021
% Version 1.3    Minor changes and comments             22 March 2021
% Version 1.4    Added user inputs                      24 March 2021

% The following is to clear the workspace and close previous figures
clear
close all
clc

%% Asynchronous Implementation single asynchronous parameter a
clc      % clear command window

% user input size of the lattice grid L
% for asynchronous simulation L < 150 is suggested
prompt1 = 'Please, enter the value L of the desired lattice grid LxL >> ';
prompt2 = 'L < 150 is suggested, do you wish to continue? 0 for yes, 1 for no >> ';
prompt3 = 'Please, enter the value L of the desired lattice grid LxL, you will not be asked this again >> ';
prompt4 = 'L needs to be an integer greater than zero, suggested values are 10 < L < 500 \nPlease reinsert the value of L >> ';
L = input(prompt1);           % user input for lattice grid L
loop_check = 0;               % variable to exit loop
while L < 0 | mod(L,1) ~= 0   % require L integer > 0
    L = input(prompt4);
end
if L > 150                    % warn L is quite big
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

% user input asynchronous parameter a
prompt1 = 'Please, enter the value for the asynchronous parameter a between 0 and 1 >> ';
prompt2 = 'Please, the asynchronous parameter a represents a probability so it needs to be between 0 and 1 \nRetry here >> ';
a = input(prompt1);       % user input for interval's upper limit
while a > 1 || a < 0      % do not accept a > 1 nor negative values
     a = input(prompt2);
end
% user input occupation probability p
prompt1 = 'Please, enter the value for the occupation probability p between 0 and 1: \n(p = 0.5 is suggested) >> ';
prompt2 = 'Please, the occupation probability p is a probability so it needs to be between 0 and 1. \nRetry here >> ';
p = input(prompt1);       % user input for interval's upper limit
while p > 1 || p < 0      % do not accept a > 1 or a < 0
     p = input(prompt2);
end
% end of user inputs

% The following is a quick way to create a matrix of
% ones and zeros with probability p and 1-p respectively
temp_parameter = 1 + p;                     % a temporary parameter between 1 and 2
lattice = ceil(rand(L,L)*temp_parameter)-1; % creates LxL matrix of zeros and ones

% Birth rule: a cell in state 0 becomes 1 iff s \in [B_l,B_h]
B_l = 3; B_h = B_l;
% Survival rule: a cell in state 1 remains 1 iff s \in [S_l,S_h]
S_l = 2; S_h = 3;

% set number of iterations
stabilization_t = 1000;              % time to reach steady state
final_t = stabilization_t + 1000;    % timesteps data recording

% start simulation, record elapsed time using tic toc functions
tic
for i = 1:stabilization_t
    % update using async_update function (see source code in async_update.m)
    lattice = async_update(lattice, a, B_l, S_h);
    % do not show figure, uncomment to show
    % imagesc(lattice);
    % axis equal;
    % axis off;
    % drawnow;
end

% After we ran the simulation for 1000 timesteps the system should have 
% reached a stable state, now at each timestep we calculate the density rho

% Initialize rho storing arrray
rho_array = zeros(1,final_t-stabilization_t);

for i = 1:(final_t-stabilization_t)
    lattice = async_update(lattice, a, B_l, S_h);   % update lattice
    tot_s = sum(sum(lattice));    % number of cells in state 1
    rho_array(i) = tot_s/(L*L);   % compute density
    % show figure in steady state
    imagesc(lattice);
    axis equal;
    axis off;
    drawnow;
end
end_timer = toc;

% communicate results by means of fprintf
fprintf('End of simulation, time elapsed : %.3g seconds \n', end_timer)
average_rho = sum(rho_array)/length(rho_array);
fprintf('The average density calculated was: %.3g with sample standard error: %.3g \n', average_rho, std(rho_array) )
fprintf('for asynchronous parameter a = %.3g, initial population density p = %.3g and lattice size L = %.3g \n', a, p, L)

%% Asynchronous simulation for a range of asynchronous parameter a
% In this code cell we are going to repeat the simulation in the cell above
% but for a range of values for the asynchronous parameter a, the other
% default parameters are lattice size L = 100 and occupation probability 
% p = 0.5. No user inputs.

% The values for the asynchronous parameter are manually selected
% such that more simulations are ran around the expected critical value
% a_c ~ 0.90
a_arr = [0.01:0.05:0.86];   % select values for a < a_c (critical point a_c)
to_add = [0.88:0.005:1];    % array of values close to expected a_c = 0.90
% defined storing array for asynchronous parameter; a_arr
a_arr(length(a_arr)+1:length(a_arr)+length(to_add)) = to_add;
a_arr_length= length(a_arr);

% initialize storing arrary for average densities rho and standard error (SE)
average_rho_array = zeros(1,a_arr_length);
err = zeros(1,a_arr_length);

% initialise system parameters
L = 100;      % size of the lattice grid
p = 0.5;      % occupation probability
temp_parameter = 1 + p;  % temporary parameter between 1 and 2
lattice = ceil(rand(L,L)*temp_parameter)-1; % creates matrix of 0's and 1's
% birth rule parameters
B_l = 3; B_h = B_l;
% survival rule parameters
S_l = 2; S_h = 3;
% set number of iterations
stabilization_t = 1000;             % time to reach steady state
final_t = stabilization_t + 1000;   % timesteps for data recording

% start simulation
tic
counter = 1;
for a = a_arr                   % iterate over selected values of a  
    for i = 1:stabilization_t   % loop to reach steady state
        lattice = async_update(lattice, a, B_l, S_h);
    end
    rho_array = zeros(1,final_t-stabilization_t);       % store densities
    for i = 1:(final_t-stabilization_t)
        lattice = async_update(lattice, a, B_l, S_h);   % update rule
        tot_s = sum(sum(lattice));     % number of cells in state 1
        rho_array(i) = tot_s/(L*L);    % compute and store density 
    end
    % find average density for specific value of a
    average_rho_array(counter) = sum(rho_array)/(final_t-stabilization_t);
    err(counter) = std(rho_array);     % compute SE
    counter = counter + 1;             % update counter
end
end_timer = toc;
fprintf('End of simulation, time elapsed : %.4g \n', end_timer)

close all    % make sure figure from cell 1 is closed
figure(1)
hold on

% to add error bars on a scatter plot the following method has been used
% from https://uk.mathworks.com/matlabcentral/answers/317051-how-do-i-add-error-bars-to-scatter-plots
errorbar(a_arr, average_rho_array, err, 'LineStyle','none','Color','r');
scatter(a_arr, average_rho_array, 100,'.b')
legend('sample error','\langle\rho(a)\rangle','fontsize',22, 'Location','southwest')
xlabel('a','fontsize', 22)
ylabel('\langle\rho(a)\rangle','fontsize', 22)
