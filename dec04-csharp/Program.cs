string input = File.ReadAllText("./input.txt");

List<ElfPair> ParseInputForElfPairs(string input)
{
	List<ElfPair> elfPairs = new List<ElfPair>();

	string[] lines = input.Split("\n");
	foreach (string line in lines)
	{
		string[] rangeStrings = line.Split(",");
		string[] boundsFirstString = rangeStrings[0].Split("-");
		string[] boundsSecondString = rangeStrings[1].Split("-");

		SectionIDRange first = new SectionIDRange
		{
			lower = Int32.Parse(boundsFirstString[0]),
			upper = Int32.Parse(boundsFirstString[1])

		};

		SectionIDRange second = new SectionIDRange
		{
			lower = Int32.Parse(boundsSecondString[0]),
			upper = Int32.Parse(boundsSecondString[1])

		};

		elfPairs.Add(new ElfPair
		{
			first = first,
			second = second
		});
	}

	return elfPairs;
}

bool ElfPairHasCover(ElfPair elfPair)
{
	return (elfPair.first.lower >= elfPair.second.lower && elfPair.first.upper <= elfPair.second.upper) ||
		(elfPair.second.lower >= elfPair.first.lower && elfPair.second.upper <= elfPair.first.upper);
}

List<ElfPair> GetElfPairsWithCover(List<ElfPair> elfPairs)
{
	List<ElfPair> elfPairsWithCover = new List<ElfPair>();

	foreach (ElfPair elfPair in elfPairs)
	{
		if (ElfPairHasCover(elfPair))
		{
			elfPairsWithCover.Add(elfPair);
		}
	}

	return elfPairsWithCover;
}

bool ElfPairHasIntersection(ElfPair elfPair)
{
	return (elfPair.first.lower >= elfPair.second.lower && elfPair.first.lower <= elfPair.second.upper) ||
		(elfPair.first.upper <= elfPair.second.upper && elfPair.first.upper >= elfPair.second.lower) ||
		(elfPair.second.lower >= elfPair.first.lower && elfPair.second.lower <= elfPair.first.upper) ||
		(elfPair.second.upper <= elfPair.first.upper && elfPair.second.upper >= elfPair.first.lower);
}

List<ElfPair> GetElfPairsWithIntersection(List<ElfPair> elfPairs)
{
	List<ElfPair> elfPairsWithIntersection = new List<ElfPair>();

	foreach (ElfPair elfPair in elfPairs)
	{
		if (ElfPairHasIntersection(elfPair))
		{
			elfPairsWithIntersection.Add(elfPair);
		}
	}

	return elfPairsWithIntersection;
}


//part 1
List<ElfPair> elfPairs = ParseInputForElfPairs(input);
List<ElfPair> elfPairsWithCover = GetElfPairsWithCover(elfPairs);
Console.WriteLine(elfPairsWithCover.Count());


//part 2
List<ElfPair> elfPairsWithIntersection = GetElfPairsWithIntersection(elfPairs);
Console.WriteLine(elfPairsWithIntersection.Count());


struct SectionIDRange
{
	public int lower;
	public int upper;
}

struct ElfPair
{
	public SectionIDRange first;
	public SectionIDRange second;

}