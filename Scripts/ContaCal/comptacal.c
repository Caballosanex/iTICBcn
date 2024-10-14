#include <stdio.h>
#include <stdlib.h>

// Defineix el nom del fitxer on es guardaran les calories acumulades
#define FILENAME "calories.txt"

// Funció per llegir les calories acumulades del fitxer
int llegir_calories_totals()
{
	FILE *file = fopen(FILENAME, "r");
	int total = 0;

	if (file != NULL)
	{
		fscanf(file, "%d", &total);
		fclose(file);
	}

	return total;
}

// Funció per guardar les noves calories acumulades al fitxer
void desar_calories_totals(int total)
{
	FILE *file = fopen(FILENAME, "w");

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

int main()
{
	int vegades;

	// Demana a l'usuari el nombre de vegades que ha pujat i baixat les escales
	printf("Introdueix el nombre de vegades que has pujat i baixat les 140 escales: ");
	if (scanf("%d", &vegades) != 1 || vegades < 0)
	{
		printf("El nombre de vegades ha de ser un nombre enter positiu!\n");
		return 1;
	}

	// Cada pujada i baixada crema 30 kcal
	int kcal_per_vegada = 30;
	int kcal_actual = vegades * kcal_per_vegada;

	// Llegeix el total de kcal desades fins ara
	int total_kcal = llegir_calories_totals();

	// Suma les noves kcal cremades
	total_kcal += kcal_actual;

	// Guarda el nou total al fitxer
	desar_calories_totals(total_kcal);

	// Mostra les kcal cremades i el total acumulat
	printf("Has cremat %d kcal avui.\n", kcal_actual);
	printf("Total acumulat de kcal cremades: %d\n", total_kcal);

	return 0;
}
