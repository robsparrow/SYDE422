%==========================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed 
% Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%==========================================================================
 
%--------------------------------------------------------------------------
% Section Title: Function to be optimized in the differential evolution
% algorithm
%--------------------------------------------------------------------------

function [bestmem,nfeval] = diffevolution_function(NP,D,F,CR,itermax,strategy,original,distorted)
% Run DE minimization
%
% Output arguments:
% ----------------
% bestmem              : parameter vector with best solution
% nfeval               : number of function evaluations
%
% Input arguments:  
% ---------------
% NP                   : number of population members
% D                    : number of parameters of the objective
%                        function
% F                    : DE-stepsize F ex [0, 2]
% CR                   : crossover probabililty constant ex [0, 1]
% itermax              : maximum number of iterations (generations)
% strategy             : 1 --> DE/best/1
%                        2 --> DE/rand/1
%                        3 --> DE/rand-to-best/1
%                        4 --> DE/best/2
%                        else  DE/rand/2

% Differential Evolution for MATLAB
% Copyright (C) June 1996 R. Storn
% International Computer Science Institute (ICSI)
% 1947 Center Street, Suite 600
% Berkeley, CA 94704
% E-mail: storn@icsi.berkeley.edu
% WWW:    http://http.icsi.berkeley.edu/~storn
%
% devec is a vectorized variant of DE which, however, has two
% properties which differ from the original version of DE:
% 1) The random selection of vectors is performed by shuffling the
%    population array. Hence a certain vector can't be chosen twice
%    in the same term of the perturbation expression.
% 2) The crossover parameters are chosen randomly, with a probability
%    according to a binomial distribution, and need not be adjacent.
%    This requires CR usually to be taken larger than in the original 
%    version of DE.
% Due to the vectorized expressions devec executes fairly fast
% in MATLAB's interpreter environment.
%
% In order to let devec optimize your own objective function you have
% to alter the code as devec was written for simplicity. 
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 1, or (at your option)
% any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details. A copy of the GNU 
% General Public License can be obtained from the 
% Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

%-----Check input variables-----------------------------------------------
if (NP < 5)
   fprintf(1,'Error! NP should be >= 5\n');
end
if ((CR < 0) | (CR > 1))
   fprintf(1,'Error! CR should be ex [0,1]\n');
end
if (itermax < 0)
   fprintf(1,'Error! itermax should be > 0\n');
end

%-----Initialize population and some arrays-------------------------------
transBounds=size(original);
pop = zeros(NP,D); %initialize pop to gain speed
lowbound1  = 0;   % Lower bound for parameters (all parameters treated alike)
highbound1 = transBounds(2)-450;   % Upper bound for parameters (all parameters treated alike)
lowbound2  = 0;    % Lower bound for parameters (all parameters treated alike)
highbound2 = transBounds(1)-450;    % Upper bound for parameters (all parameters treated alike)
lowbound3 = .5;
highbound3=1.5;

%----pop is a matrix of size NPxD. It will be initialized-------------
%----with random values between highbound and lowbound----------------

for i=1:NP
   pop(i,1) = lowbound1 + rand*(highbound1 - lowbound1);
   pop(i,2) = lowbound2 + rand*(highbound2 - lowbound2);
%    pop(i,3) = lowbound3 + rand*(highbound3 - lowbound3);
end

popold    = zeros(size(pop));     % toggle population
val       = zeros(1,NP);          % create and reset the "cost array"
bestmem   = zeros(1,D);           % best population member ever
bestmemit = zeros(1,D);           % best population member in iteration
nfeval    = 0;                    % number of function evaluations

%------Evaluate the best member after initialization----------------------

ibest   = 1;                      % start with first population member

%------Function that is being evaluated------------------------------------
%Apply a set of transformations to the distorted image
imgRegistered = distorted; 
% distorted=imresize(distorted,pop(i,3));
cropWindow = [pop(ibest,1) pop(ibest,2) 200 200];
originalSegment = imcrop(original,cropWindow);
cropWindow = [0 0 200 200];
imgRegistered = imcrop(imgRegistered,cropWindow);
similarityMeasure=momi(imgRegistered, originalSegment, 'Normalized');
val(1)=-similarityMeasure;
%--------------------------------------------------------------------------

bestval = val(1);                 % best objective function value so far
nfeval  = nfeval + 1;
for i=2:NP                        % check the remaining members
    
%------Function that is being evaluated------------------------------------
%Apply a set of transformations to the distorted image
imgRegistered = distorted;
% distorted=imresize(distorted,pop(i,3));
cropWindow = [pop(i,1) pop(i,2) 200 200];
originalSegment = imcrop(original,cropWindow);
cropWindow = [0 0 200 200];
imgRegistered = imcrop(imgRegistered,cropWindow);
similarityMeasure=momi(imgRegistered, originalSegment, 'Normalized');
val(i)=-similarityMeasure;
%--------------------------------------------------------------------------

  nfeval  = nfeval + 1;
  if (val(i) < bestval)           % if member is better
     ibest   = i;                 % save its location
     bestval = val(i);
  end   
end
bestmemit = pop(ibest,:);         % best member of current iteration
bestvalit = bestval;              % best value of current iteration

bestmem = bestmemit;              % best member ever

%------DE-Minimization---------------------------------------------
%------popold is the population which has to compete. It is--------
%------static through one iteration. pop is the newly--------------
%------emerging population.----------------------------------------

pm1 = zeros(NP,D);              % initialize population matrix 1
pm2 = zeros(NP,D);              % initialize population matrix 2
pm3 = zeros(NP,D);              % initialize population matrix 3
pm4 = zeros(NP,D);              % initialize population matrix 4
pm5 = zeros(NP,D);              % initialize population matrix 5
bm  = zeros(NP,D);              % initialize bestmember  matrix
ui  = zeros(NP,D);              % intermediate population of perturbed vectors
mui = zeros(NP,D);              % mask for intermediate population
mpo = zeros(NP,D);              % mask for old population
rot = (0:1:NP-1);               % rotating index array
rt  = zeros(NP);                % another rotating index array
a1  = zeros(NP);                % index array
a2  = zeros(NP);                % index array
a3  = zeros(NP);                % index array
a4  = zeros(NP);                % index array
a5  = zeros(NP);                % index array
ind = zeros(4);

iter = 1;
while ((iter < itermax) & (bestval > 1.e-6))
  popold = pop;                   % save the old population

  ind = randperm(4);              % index pointer array

  a1  = randperm(NP);             % shuffle locations of vectors
  rt = rem(rot+ind(1),NP);        % rotate indices by ind(1) positions
  a2  = a1(rt+1);                 % rotate vector locations
  rt = rem(rot+ind(2),NP);
  a3  = a2(rt+1);                
  rt = rem(rot+ind(3),NP);
  a4  = a3(rt+1);               
  rt = rem(rot+ind(4),NP);
  a5  = a4(rt+1);                

  pm1 = popold(a1,:);             % shuffled population 1
  pm2 = popold(a2,:);             % shuffled population 2
  pm3 = popold(a3,:);             % shuffled population 3
  pm4 = popold(a4,:);             % shuffled population 4
  pm5 = popold(a5,:);             % shuffled population 5

  for i=1:NP                      % population filled with the best member
    bm(i,:) = bestmemit;          % of the last iteration
  end

  mui = rand(NP,D) < CR;          % all random numbers < CR are 1, 0 otherwise
  mpo = mui < 0.5;                % inverse mask to mui

  if (strategy == 1)                % DE/best/1
    ui = bm + F*(pm1 - pm2);        % differential variation
    ui = popold.*mpo + ui.*mui;     % binomial crossover
  elseif (strategy == 2)            % DE/rand/1
    ui = pm3 + F*(pm1 - pm2);       % differential variation
    ui = popold.*mpo + ui.*mui;     % binomial crossover
  elseif (strategy == 3)            % DE/rand-to-best/1
    ui = popold + F*(bm-popold) + F*(pm1 - pm2);        
    ui = popold.*mpo + ui.*mui;     % binomial crossover
  elseif (strategy == 4)            % DE/best/2
    ui = bm + F*(pm1 - pm2 + pm3 - pm4);  % differential variation
    ui = popold.*mpo + ui.*mui;           % binomial crossover
  else                              % DE/rand/2
    ui = pm5 + F*(pm1 - pm2 + pm3 - pm4);  % differential variation
    ui = popold.*mpo + ui.*mui;            % binomial crossover
  end

%-----Select which vectors are allowed to enter the new population------------
  for i=1:NP
      
%------Function that is being evaluated------------------------------------
%Apply a set of transformations to the distorted image
imgRegistered = distorted; 
% distorted=imresize(distorted,pop(i,3));
cropWindow = [pop(i,1) pop(i,2) 200 200];
originalSegment = imcrop(original,cropWindow);
cropWindow = [0 0 200 200];
imgRegistered = imcrop(imgRegistered,cropWindow);
similarityMeasure=momi(imgRegistered, originalSegment, 'Normalized');
val(i)=-similarityMeasure;
%--------------------------------------------------------------------------

    nfeval  = nfeval + 1;
    if (tempval <= val(i))  % if competitor is better than value in "cost array"
       pop(i,:) = ui(i,:);  % replace old vector with new one (for new iteration)
       val(i)   = tempval;  % save value in "cost array"

       %----we update bestval only in case of success to save time-----------
       if (tempval < bestval)     % if competitor better than the best one ever
          bestval = tempval;      % new best value
          bestmem = ui(i,:);      % new best parameter vector ever
       end
    end
  end %---end for imember=1:NP

  bestmemit = bestmem;       % freeze the best member of this iteration for the coming 
                             % iteration. This is needed for some of the strategies.

%----Output section----------------------------------------------------------

  if (rem(iter,10) == 0)
     fprintf(1,'Iteration: %d,  Best: %f,  F: %f,  CR: %f,  NP: %d\n',iter,bestval,F,CR,NP);
     for n=1:D
       fprintf(1,'best(%d) = %f\n',n,bestmem(n));
     end
  end

%----Continue
%plotting-------------------------------------------------------
  iter = iter + 1;
end %---end while ((iter < itermax) ...