function [distances, surface_points] = inverse_search(FV2,target_coords)
warning off


% find nearest point on surface of mesh
[distances,surface_points] = point2trimesh(FV2, 'QueryPoints', target_coords);


patch(FV2,'FaceAlpha',.5); xlabel('x'); ylabel('y'); zlabel('z'); axis equal; hold on
plot3M = @(XYZ,varargin) plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),varargin{:});
plot3M(target_coords,'*r')
plot3M(surface_points,'*k')
plot3M(reshape([shiftdim(target_coords,-1);shiftdim(surface_points,-1);shiftdim(target_coords,-1)*NaN],[],3),'k')

end

% serious artifact removal base work
% % % fprintf('select top left brain artifacts\n')
% % % plot3(rcv(:,1),rcv(:,2),rcv(:,3),'o')
% % % view(2)
% % % roi = drawpolygon('Color','r','LineWidth',30);
% % % 
% % % xq = (1:max(size(target_cluster)));                            % Grid X-Coordinates
% % % yq = (1:max(size(target_cluster)));                            % Grid Y-Coordinates
% % % [XQ,YQ] = meshgrid(xq,yq);
% % % xv = [roi.Position(:,1)' roi.Position(1,1)];                                    % Polygon X-Coordinates
% % % yv = [roi.Position(:,2)' roi.Position(1,2)];                                    % Polygon Y-Coordinates
% % % [in,on] = inpolygon(XQ,YQ, xv,yv);                          % Logical Matrix
% % % inon = in | on;                                             % Combine ‘in’ And ‘on’
% % % idx = find(inon(:));                                        % Linear Indices Of ‘inon’ Points
% % % xcoord = XQ(inon)';                                           % X-Coordinates Of XinonQ Points
% % % ycoord = YQ(inon)';
% % % 
% % % iRemove = sub2ind(size(target_cluster,1:2),xcoord,ycoord);
% % % 
% % % target_clusterc = target_cluster;
% % % 
% % % numPages = size(target_clusterc,3);
% % % numRemove = numel(ycoord);
% % % for k = 1:numPages
% % %     kPage = repmat(k,1,numRemove); % same (current) page for each point
% % %     iRemove = sub2ind(size(target_clusterc),ycoord,xcoord,kPage);
% % %     targetclusterc(iRemove) = 0;
% % % end
% % % 
% % % target_clusterc(1:30,400:450,:) = 0;
% % % 
% % % [r,c,v] = ind2sub(size(target_clusterc),find(target_clusterc==255));
% % % rcv = [r c v];
% % % 
% % % 




% % % fprintf('select top right brain artifacts\n')
% % % plot3(rcv(:,1),rcv(:,2),rcv(:,3),'o')
% % % view(2)
% % % roi = drawpolygon('Color','r','LineWidth',30);
% % % 
% % % xq = (1:max(size(target_cluster)));                            % Grid X-Coordinates
% % % yq = (1:max(size(target_cluster)));                            % Grid Y-Coordinates
% % % [XQ,YQ] = meshgrid(xq,yq);
% % % xv = [roi.Position(:,1)' roi.Position(1,1)];                                    % Polygon X-Coordinates
% % % yv = [roi.Position(:,2)' roi.Position(1,2)];                                    % Polygon Y-Coordinates
% % % [in,on] = inpolygon(XQ,YQ, xv,yv);                          % Logical Matrix
% % % inon = in | on;                                             % Combine ‘in’ And ‘on’
% % % idx = find(inon(:));                                        % Linear Indices Of ‘inon’ Points
% % % xcoord = XQ(idx)';                                           % X-Coordinates Of XinonQ Points
% % % ycoord = YQ(idx)';
% % % 
% % % target_clusterc(xcoord,ycoord,:) = 0;
% % % target_clusterc(300:350,400:450,:) = 0;
% % % 
% % % [r,c,v] = ind2sub(size(target_clusterc),find(target_clusterc==255));
% % % rcv = [r c v];
% % % plot3(rcv(:,1),rcv(:,2),rcv(:,3),'o')
% % % view(2)


