%==========================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed 
% Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%==========================================================================
 
%--------------------------------------------------------------------------
% Section Title: Genetic Algorithm Options
% Main purpose is to specify the mutation, creation, and population
% initialization functions such that parameters take on only integer values
% in the specified range.
%--------------------------------------------------------------------------

function options = ga_options(original, distorted, generations, popSize)
% Specify options related to the performance of the GA
transBounds=size(original);
rangeMatrix = zeros(2,2);
% rangeMatrix(:,1) = [-20;20];
% Note the -450 value is to ensure there is enough overlap of the images for
% a comparison based on MI, and to prevent translation falling outside
% image range
rangeMatrix(:,1) = [0;transBounds(2)-450];
rangeMatrix(:,2) = [0;transBounds(1)-450];
% rangeMatrix(:,3) = [80;120]; %Changed to real number in genetic_function

options = gaoptimset('CreationFcn',@int_pop,'MutationFcn',@int_mutation, ...
    'PopInitRange',rangeMatrix,'Generations',generations, ...
    'PopulationSize',popSize, 'PlotFcns', @gaplotbestf);

function mutationChildren = int_mutation(parents,options,GenomeLength, ...
    FitnessFcn,state,thisScore,thisPopulation)
shrink = .01; 
scale = 1;
scale = scale - shrink * scale * state.Generation/options.Generations;
range = options.PopInitRange;
lower = range(1,:);
upper = range(2,:);
scale = scale * (upper - lower);
mutationPop =  length(parents);
mutationChildren =  repmat(lower,mutationPop,1) +  ...
    round(repmat(scale,mutationPop,1) .* rand(mutationPop,GenomeLength));

function Population = int_pop(GenomeLength,FitnessFcn,options)
totalpopulation = sum(options.PopulationSize);
range = options.PopInitRange;
lower= range(1,:);
span = range(2,:) - lower;
Population = repmat(lower,totalpopulation,1) +  ...
    round(repmat(span,totalpopulation,1) .* rand(totalpopulation,GenomeLength));