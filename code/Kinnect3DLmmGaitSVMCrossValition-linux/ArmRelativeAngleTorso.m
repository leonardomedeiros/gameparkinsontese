%Em matemática, em álgebra linear, o produto escalar é uma função binária definida entre dois vetores que fornece um número real (também chamado "escalar") como resultado. É o produto interno padrão do espaço euclidiano.
%O produto vetorial, que é outra operação possível de ser definir para vetores fornece, por outro lado, um novo vetor. 
function [ angle ] = ArmRelativeAngleTorso(torsoJoint, shoulderJoint, elbowJoint, Index)

% CONSTANT_RADIANUS_TO_DEGRES = 57.3;
% 
% B = LengthJoint(shoulderJoint, elbowJoint, Index);
% C = LengthJoint(elbowJoint, wristJoint, Index);
% A = LengthJoint(shoulderJoint, wristJoint, Index);
% 
% 
% 	
% 
% radianos = acos(COSTETA)
% angle = radianos * CONSTANT_RADIANUS_TO_DEGRES

torso = [torsoJoint(Index,2),torsoJoint(Index,3), torsoJoint(Index,4)];
shoulder = [shoulderJoint(Index,2),shoulderJoint(Index,3), shoulderJoint(Index,4)];
elbow = [elbowJoint(Index,2),elbowJoint(Index,3), elbowJoint(Index,4)];


u = torso-shoulder;
v = elbow-shoulder;

CosTheta = dot(u,v)/(norm(u)*norm(v));
ThetaInDegrees = acos(CosTheta)*180/pi;
angle = ThetaInDegrees;
%angle = acos(dot(w-e,s-e)/(norm(w-e)*norm(s-e)))*180/pi
end