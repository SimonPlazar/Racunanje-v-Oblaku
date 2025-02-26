#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <cmath>

#define MOD 360.0
#define TARGET_SUM 270.510

int main(int argc, char* argv[]) {
    int rank, size, num_pongs = 0;
    double rand_num, sum = 0.0;
    
    // Inicializacija MPI
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // Seed random generator za naključna števila
    srand(time(NULL));

    if (rank == 0) {
        // Glavno vozlišče (rank 0) pošlje naključno število vsem odjemalcem
        while (sum < TARGET_SUM - 0.005 || sum > TARGET_SUM + 0.005) {
            num_pongs++;
            rand_num = ((double) rand() / RAND_MAX) * 180.0;  // Naključno število med 0.0 in 180.0
            printf("Sending random number %.2f from rank 0\n", rand_num);
            
            // Pošlji vsem odjemalcem
            for (int i = 1; i < size; i++) {
                MPI_Send(&rand_num, 1, MPI_DOUBLE, i, 0, MPI_COMM_WORLD);
            }

            // Prejmi številke od odjemalcev
            for (int i = 1; i < size; i++) {
                MPI_Recv(&rand_num, 1, MPI_DOUBLE, i, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
				sum = fmod(sum + rand_num, MOD);
            }

            printf("Current sum (mod 360): %.2f\n", sum);
        }

        // Izpis rezultatov
        printf("PingPong communication finished after %d rounds\n", num_pongs);
        FILE *file = fopen("RESULT.TXT", "w");
        fprintf(file, "PingPong communication finished after %d rounds\n", num_pongs);
        fclose(file);

    } else {
        // Odjemalec (vse razen rank 0)
        while (sum < TARGET_SUM - 0.005 || sum > TARGET_SUM + 0.005) {
            // Prejmi število
            MPI_Recv(&rand_num, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

            // Pošlji število nazaj glavnemu vozlišču
            MPI_Send(&rand_num, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD);
        }
    }

    // Končanje MPI
    MPI_Finalize();
    return 0;
}