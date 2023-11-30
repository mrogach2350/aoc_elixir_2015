package main

import (
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

func createMatrix() [][]int {
	var matrix [][]int

	for i := 0; i <= 999; i++ {
		row := make([]int, 999)
		for j := 0; j <= 999; j++ {
			row = append(row, 0)
		}
		matrix = append(matrix, row)
	}

	return matrix
}

type Instruction struct {
	Change string
	StartX int
	StartY int
	EndX   int
	EndY   int
}

func parseInstructionLine(i string) Instruction {
	parts := strings.Split(i, " ")
	if len(parts) == 5 {
		start := strings.Split(parts[2], ",")
		end := strings.Split(parts[4], ",")

		startX, _ := strconv.Atoi(start[0])
		startY, _ := strconv.Atoi(start[1])
		endX, _ := strconv.Atoi(end[0])
		endY, _ := strconv.Atoi(end[1])

		return Instruction{
			Change: fmt.Sprintf("%s %s", parts[0], parts[1]),
			StartX: startX,
			StartY: startY,
			EndX:   endX,
			EndY:   endY,
		}
	} else {
		start := strings.Split(parts[1], ",")
		end := strings.Split(parts[3], ",")

		startX, _ := strconv.Atoi(start[0])
		startY, _ := strconv.Atoi(start[1])
		endX, _ := strconv.Atoi(end[0])
		endY, _ := strconv.Atoi(end[1])

		return Instruction{
			Change: parts[0],
			StartX: startX,
			StartY: startY,
			EndX:   endX,
			EndY:   endY,
		}
	}
}

func solvePartOne(instructions []string) int {
	matrix := createMatrix()
	for _, d := range instructions {
		if d == "" {
			continue
		}
		instruction := parseInstructionLine(d)
		for i := instruction.StartY; i <= instruction.EndY; i++ {
			for j := instruction.StartX; j <= instruction.EndX; j++ {
				if instruction.Change == "turn on" {
					matrix[i][j] = 1
				} else if instruction.Change == "turn off" {
					matrix[i][j] = 0
				} else if instruction.Change == "toggle" {
					if matrix[i][j] == 1 {
						matrix[i][j] = 0
					} else {
						matrix[i][j] = 1
					}
				}
			}
		}
	}

	result := 0
	for _, row := range matrix {
		for _, i := range row {
			result += i
		}
	}

	return result
}

func solvePartTwo(instructions []string) int {
	matrix := createMatrix()
	for _, d := range instructions {
		if d == "" {
			continue
		}
		instruction := parseInstructionLine(d)
		for i := instruction.StartY; i <= instruction.EndY; i++ {
			for j := instruction.StartX; j <= instruction.EndX; j++ {
				if instruction.Change == "turn on" {
					matrix[i][j] = matrix[i][j] + 1
				} else if instruction.Change == "turn off" {
					if matrix[i][j] != 0 {
						matrix[i][j] = matrix[i][j] - 1
					}
				} else if instruction.Change == "toggle" {
					matrix[i][j] = matrix[i][j] + 2

				}
			}
		}
	}

	result := 0
	for _, row := range matrix {
		for _, i := range row {
			result += i
		}
	}

	return result
}

func main() {
	data, err := os.ReadFile("./input.txt")
	if err != nil {
		log.Fatal("error reading input")
	}
	instructions := strings.Split(string(data), "\n")
	resultOne := solvePartOne(instructions)
	resultTwo := solvePartTwo(instructions)

	fmt.Printf("Part One Result = %v \n", resultOne)
	fmt.Printf("Part One Expected = %v \n", 569999)
	fmt.Printf("Part Two Result = %v \n", resultTwo)
	fmt.Printf("Part Two Expected = %v \n", 17836115)
}
