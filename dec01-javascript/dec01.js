import input from './dec01-input.js'

//part 1
const sets = input.split("\n\n")

const max = sets.reduce((max, set) => {
	const values = set.split("\n").map(value => parseInt(value))
	const sum = values.reduce((sum, value) => sum + value, 0)
	return Math.max(max, sum)
}, 0)

console.log(max)

//part 2
const sums = sets.map(set => {
	const values = set.split("\n").map(value => parseInt(value))
	const sum = values.reduce((sum, value) => sum + value, 0)
	return sum
}).sort()

console.log(sums[sums.length - 1] + sums[sums.length - 2] + sums[sums.length - 3])
