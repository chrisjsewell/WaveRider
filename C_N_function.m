function D = C_N_function(h_bar, i, m, delta_x, delta_t, v_x, b)

%Creating vectors for tri-diagonal matrix creation
size=length(v_x);
vector=ones(size, 1);
vector_b=ones(size-1,1);


alpha= (i*h_bar/delta_t)*vector - (h_bar*h_bar/(2*m*delta_x*delta_x))*vector - v_x/2;
beta= h_bar*h_bar/(4*m*delta_x*delta_x);
vec_beta= beta*vector_b;
gamma = 2*beta*vector + v_x/2+i*h_bar/delta_t*vector;


A=gallery('tridiag',vec_beta,alpha,vec_beta); %Tridiagonal matrix for zero BC's
C=gallery('tridiag',-vec_beta,gamma,-vec_beta); %Tridiagonal matrix for r_x

if b==1 %Adds elements for periodic BC's
    A(1,size)=beta;
    A(size,1)=beta;
    C(1,size)=-beta;
    C(size,1)=-beta;
end

B=inv(A); %Inverted tridiagonal matrix
D=B*C; %Solver matrix