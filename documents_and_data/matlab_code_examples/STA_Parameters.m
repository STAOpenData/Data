% -------------------------------------------------------------------------
%% STA Parameters for each segment calculated as detailed in the Cereatti et al.(2017)
% INPUT
%     STA (Struct)     Skin-marker trajectories (M01, M02,...) represented in the relevant ACS
%                      Each marker trajectory is [nx3]
%     mrk (3x3)        Name of the skin-markers
%
% OUTPUT
%      d               Instantaneous displacement vector
%      rmsd            Root mean square amplitude (rmsd.mod) and its
%                      components (rmsd.x, rmsd.y, rmsd.z) 
%      deltap          Peak-to-peak amplitude, maximum value (deltap.max)
%                      and relevant components (deltap.x, deltap.y, deltap.z)
% -------------------------------------------------------------------------
%%

function [rmsd, deltap, d] = STA_Parameters(STA,mrk)

for j = 1:size(mrk,2)
    STAnow = STA.(mrk{j});
    n = size(STAnow,1);
    for k = 1:n 
            STAvect (k,:) = STAnow(k,:);
            STAvectx (k,1) = STAnow(k,1);
            STAvecty (k,1) = STAnow(k,2);
            STAvectz (k,1) = STAnow(k,3);
     end
    
    pmeanx = mean(STAvectx);
    pmeany = mean(STAvecty);
    pmeanz = mean(STAvectz);
    
    for k = 1:n 
        D(k,1) = norm(STAvect(k,:) - mean(STAnow));
        d.(mrk{j})(k,:) = STAvect(k,:) - mean(STAnow);
       
        dx(k,1) = STAvectx(k,1) - pmeanx;
        dy(k,1) = STAvecty(k,1) - pmeany;
        dz(k,1) = STAvectz(k,1) - pmeanz;
    end
    
    rmsd.mod(j,1) = rms(D);
    rmsd.x(j,1) = rms(dx);
    rmsd.y(j,1) = rms(dy);
    rmsd.z(j,1) = rms(dz); 
    
    % Deltap max
    P = STAnow;  
    [M N] = size(P); % Number of points and number of dimensions

    % METHOD 1 (quick, without loops)

    if M < 500
        % Distances between pairs of points
        P  = shiftdim(P, -1);     % (1×M×N)
        P2 = reshape(P, [M 1 N]); % (M×1×N)
        dd = bsxfun(@minus, P, P2); % Distance vectors (M×M×N)
        dd = magn(dd, 3); % Scalar distances (M×M)

        % Row and column containing maximum value in DD
        [dd,  rows] = max(dd); % (1×M)
        [Deltap, column] = max(dd); % (1×1)

    % METHOD 2 (slower, but requires a much smaller amount of memory)
    else
        dd  = zeros(M-1, 1);
        ii2 = zeros(M-1, 1);
        for i = 1 : (M-1)
           next = (i+1) : M;
           Deltap = bsxfun(@minus, P(i,:), P(next,:)); % Distances (M-i1×N)
           Deltap = magn(Deltap, 2); % Scalar distances (M-i1×1)
           [dd(i), j] = max(Deltap);
           ii2(i) = i + j;
        end

        [Deltap, i1] = max(dd);
    end

    deltap.max(j,1) = Deltap;
    
    deltap.x(j,1) = (max(STAnow(:,1))- min(STAnow(:,1)));
    deltap.y(j,1) = (max(STAnow(:,2))- min(STAnow(:,2)));
    deltap.z(j,1) = (max(STAnow(:,3))- min(STAnow(:,3)));
end