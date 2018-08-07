/*
 *  
 *  formationcoordinates.cpp
 *  This file created by Casey Brito.
 *  This program takes in a PGM file and outputs MATLAB syntax to be used in Mobile Agent Simulator
 *  for the desired formation shape we desire the agents to attain.
 *  Each white pixel in the PGM file is interpreted as one (1) agent. 
 *
*/

#include <iostream>
#include <fstream>
#include <vector>
#include <string>

using namespace std;

//Function to read the PGM file
vector<vector<int> > readPGM(string filename) {
    
    //Begin by opening the given PGM
    ifstream pgm;
	pgm.open(filename.c_str());
	
	//Exit if we can't open the PGM file
	if(!pgm) {
	    cout << "Error! Could not open " << filename << "!" << endl;
	    return vector<vector<int> >();
	}
	
	//Make sure that the file we're taking in is a P2 PGM
	string type;
	getline(pgm,type);
	if(type.compare("P2") != 0) {
	    cout << "Error! " << filename << " is not a P2 PGM file." << endl;
        return vector<vector<int> >();
	}
	
	//Get the dimensions of the board
	unsigned int M, N, W;
	pgm >> M;   //Number of rows
	pgm >> N;   //Number of columns
	pgm >> W;   //For convenience we will assume that the max whiteness is 1.
	
	//Create the PGM in matrix form
	vector<vector<int> > A(M, vector<int>(N));
	
	//Copy the data from the PGM into the matrix
	for(int i = 0; i < M; i++) {
	    for(int j = 0; j < N; j++) {
	        pgm >> A[i][j];
	    }
	}
	
	//Close the file now that we're done with it.
	pgm.close();

    return A;
}

//Counts the number of agents necessary for the simulation based on the PGM
unsigned int countNumberOfAgents(vector<vector<int> > &A) {
    int count = 0;
    
    for(int i = 0; i < A.size(); i++) {
        for(int j = 0; j < A[0].size(); j++) {
            if(A[i][j] != 0) {
                count++;
            }
        }
    }
    
    return count;
}

int main(int argc, char **argv) {
    
    cout << "Type the path of the PGM file you want to convert to MATLAB coordinates: ";
    
    //Get filename
    string filename;
    getline(cin, filename);
    
    //Parse the data from the PGM
    vector<vector<int> > A = readPGM(filename);
    
    //If there is a problem with the file, immediately quit
    if(A.empty()) {
        return 0;
    }
    
    //Determine how to number the agents
    cout << "Is there a particular ordering the agents should have from the PGM? (row-by-row top to bottom). Enter y/n: ";
    char choice;
    cin >> choice;
    
    if(choice == 'n') {
        
        //Print the results
        cout << "Use the following vector in MATLAB for Mobile Agent Simulator:" << endl;
        cout << "\ncoordinates = [";
    
        //Here, we assume the agents are numbers as they come in from left-to-right, top-to-bottom
        for(int i = 0; i < A.size(); i++) {
            for(int j = 0; j < A[0].size(); j++) {
               if(A[i][j] == 1) {
                  cout << A.size() - 1 - i << " " << j << "; ";
                 }
             }
        }
        
        //End the vector notation for MATLAB
        cout << "\b];" << endl;
        
    } else {
    
        cout << "Enter in the order we should number the agents: ";
        unsigned int numberOfAgents = countNumberOfAgents(A), agentIndex;
        vector<vector<int> > matlabVector(numberOfAgents, vector<int>(2));
        
        for(int i = 0; i < A.size(); i++) {
            for(int j = 0; j < A[0].size(); j++) {
                if(A[i][j] == 1) {
                    cin >> agentIndex;
                    matlabVector[agentIndex - 1][0] = A.size() - 1 - i;
                    matlabVector[agentIndex - 1][1] = j;
                }
            }
        }
        
        //Print the results
        cout << "Use the following vector in MATLAB for Mobile Agent Simulator:" << endl;
        cout << "\ncoordinates = [";
        
        //Print the MATLAB vector in the desired order
        for(int i = 0; i < matlabVector.size(); i++) {
            for(int j = 0; j < matlabVector[0].size(); j++) {
                cout << matlabVector[i][j] << " ";
            }
            cout << "\b; ";
        }
        
        //End the vector notation for MATLAB
        cout << "\b];" << endl;
    }
    
    return 0;
}
