import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

public class Main {
	int[][] grid;

	public Main() {
		initGrid();

		int visibleTreeCount = 0;
		for (int row = 0; row < grid.length; row++) {
			for (int col = 0; col < grid[row].length; col++) {
				if (isVisible(row, col)) {
					visibleTreeCount++;
				}
			}
		}

		int maxScenicScore = 0;
		for (int row = 0; row < grid.length; row++) {
			for (int col = 0; col < grid[row].length; col++) {
				maxScenicScore = Math.max(maxScenicScore, getScenicScore(row, col));
			}
		}

		System.out.println(getScenicScore(1, 2));
		System.out.println("visible tree count: " + visibleTreeCount);
		System.out.println("max scenic score: " + maxScenicScore);
	}

	public int[][] initGrid() {
		ArrayList<String> lines = new ArrayList<>();

		try {
			File file = new File("./dec08-java/input.txt");
			Scanner scanner = new Scanner(file);

			while (scanner.hasNextLine()) {
				lines.add(scanner.nextLine());
			}

			scanner.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}

		int lineCount = lines.size();
		int lineLength = lines.get(0).length();

		grid = new int[lineCount][lineLength];

		for (int row = 0; row < lineCount; row++) {
			for (int col = 0; col < lineLength; col++) {
				grid[row][col] = (int) Integer.parseInt(("" + lines.get(row).charAt(col)));
			}
		}

		return grid;
	}

	boolean isVisibleThroughRow(int row, int col) {
		int height = grid[row][col];

		if (col == 0 || col == grid[row].length - 1) {
			return true;
		}

		// march up
		boolean visibleUp = true;
		for (int curCol = col -1; curCol >= 0; curCol--) {
			if (grid[row][curCol] >= height) {
				visibleUp = false;
			}
		}

		// march down
		boolean visibleDown = true;
		for (int curCol = col + 1; curCol < grid[row].length; curCol++) {
			if (grid[row][curCol] >= height) {
				visibleDown = false;
			}
		}

		return visibleUp || visibleDown;
	}

	boolean isVisibleThroughColumn(int row, int col) {
		int height = grid[row][col];

		if (row == 0 || row == grid.length - 1) {
			return true;
		}

		// march left
		boolean visibleUp = true;
		for (int curRow = row - 1; curRow >= 0; curRow--) {
			if (grid[curRow][col] >= height) {
				visibleUp = false;
			}
		}

		// march right
		boolean visibleDown = true;
		for (int curRow = row + 1; curRow < grid.length; curRow++) {
			if (grid[curRow][col] >= height) {
				visibleDown = false;
			}
		}

		return visibleUp || visibleDown;
	}

	boolean isVisible(int row, int col) {
		return isVisibleThroughColumn(row, col) || isVisibleThroughRow(row, col);
	}

	int getRightVisibilityDistance(int row, int col) {
		int height = grid[row][col];
		int dist = 0;

		if(col == grid[row].length - 1) {
			return 0;
		}

		for (int curCol = col + 1; curCol < grid[row].length; curCol++) {
			dist++;
			if (grid[row][curCol] >= height) {
				break;
			}
		}

		return dist;
	}

	int getLeftVisibilityDistance(int row, int col) {
		int height = grid[row][col];
		int dist = 0;

		if(col == 0) {
			return 0;
		}

		for (int curCol = col - 1; curCol >= 0; curCol--) {
			dist++;
			if (grid[row][curCol] >= height) {
				break;
			}
		}

		return dist;
	}

	int getUpVisibilityDistance(int row, int col) {
		int height = grid[row][col];
		int dist = 0;

		if(row == 0) {
			return 0;
		}

		for (int curRow = row - 1; curRow >= 0; curRow--) {
			dist++;
			if (grid[curRow][col] >= height) {
				break;
			}
		}

		return dist;
	}

	int getDownVisibilityDistance(int row, int col) {
		int height = grid[row][col];
		int dist = 0;

		if(row == grid.length - 1) {
			return 0;
		}

		for (int curRow = row + 1; curRow < grid.length; curRow++) {
			dist++;
			if (grid[curRow][col] >= height) {
				break;
			}
		}

		return dist;
	}

	int getScenicScore(int row, int col) {
		int right = getRightVisibilityDistance(row, col);
		int left =getLeftVisibilityDistance(row, col);
		int up =getUpVisibilityDistance(row, col);
		int down =getDownVisibilityDistance(row, col);

		return right*left*up*down;
	}

	public static void main(String[] args) {
		Main main = new Main();
	}
}