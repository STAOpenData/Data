% -------------------------------------------------------------------------
%% Plotting 3-D reference frame axes defined by t and R
%     t (3x1)          Origin position
%     R (3x3)          Orientation of the axes (each column of the 
%                      matrix represents an axis)
%     scale (1x1)      Scale factor for axes dimension
%
% The axes are plotted using the following convention:
%     x-axis --> red line
%     y-axis --> green line
%     z-axis --> blue line
% -------------------------------------------------------------------------
%%

function my3Dplot(t,R,scale,linewidth)
    e = t*ones(1,3)+scale*R;

    plot3([t(1),e(1,1)],[t(2),e(2,1)],[t(3),e(3,1)],'r-','Linewidth',linewidth);
    plot3([t(1),e(1,2)],[t(2),e(2,2)],[t(3),e(3,2)],'g-','Linewidth',linewidth);
    plot3([t(1),e(1,3)],[t(2),e(2,3)],[t(3),e(3,3)],'b-','Linewidth',linewidth);
end