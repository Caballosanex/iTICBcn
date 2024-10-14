#include <stdio.h>
#include <stdlib.h>

#define FILENAME "calories.txt"

int llegirCaloriesTotals() {
	FILE *file = fopen(FILENAME, "r");
	int total = 0;

	if (file != NULL)
	{
		fprintf(file, "%d", total);
		fclose(file);
	}
	else
	{
		printf("Error obrint el fitxer!\n");
	}
}

int main() {
	int vegades = 0;

	printf("Quantes vegades has pujat les escales avui? ");
	if (scanf("%d", &vegades != 1) || vegades < 0) {
		printf("Error: has d'introduir un nombre enter positiu!\n");
		return 1;
	}

	int kcal_per_vegada = 30;
	int kcal_actual = vegades * kcal_per_vegada;
	int total_kcal = llegirCaloriesTotals();

	total_kcal += kcal_actual;
	desar_kcal_total(total_kcal);

	printf("Has cremat avui %d kcal.\n", kcal_actual);
	printf("Portes un total de %d kcal.\n", total_kcal);

	return 0;
}