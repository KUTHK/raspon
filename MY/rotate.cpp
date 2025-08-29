#include<bits/stdc++.h>
#include<vector>
#include<iostream>
using namespace std;

int N = 8;

vector<vector<int>>A(N, vector<int>(N));
vector<vector<int>>Aswap(N, vector<int>(N));

void make_swap(int x1, int y1, int x2, int y2){ 
  Aswap[x2][y2] = A[x1][y1];
}

void init(){
  A[4][1] = 1;
  A[5][1] = 1;
  A[6][1] = 1;
  A[6][2] = 1;
  A[6][3] = 1;
  A[5][3] = 1;
  A[4][3] = 1;
  A[4][4] = 1;
  A[4][5] = 1;
  A[5][5] = 1;
  A[6][5] = 1;

}

int main(){
  init();
  for(int y = 0; y < N;y++){
    for(int x = 0; x < N; x++){
      make_swap(x, y, y, x);
    }
  }

  for(int y = 0; y < N;y++){
    for(int x = 0; x < N; x++){
      cout<<A[x][y]<<" ";
    }
    cout<<endl;
  }
  cout<<endl;

  for(int y = 0; y < N;y++){
    for(int x = 0; x < N; x++){
      cout<<Aswap[x][y]<<" ";
    }
    cout<<endl;
  }
}
