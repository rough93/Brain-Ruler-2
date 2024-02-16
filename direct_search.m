function [distances, surface_points] = direct_search(FV3,target_coords)
warning off


% find nearest point on surface of mesh
[distances,surface_points] = point2trimesh(FV3, 'QueryPoints', target_coords);


patch(FV3,'FaceAlpha',.5); xlabel('x'); ylabel('y'); zlabel('z'); axis equal; hold on
plot3M = @(XYZ,varargin) plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),varargin{:});
plot3M(target_coords,'*r')
plot3M(surface_points,'*k')
plot3M(reshape([shiftdim(target_coords,-1);shiftdim(surface_points,-1);shiftdim(target_coords,-1)*NaN],[],3),'k')

end
