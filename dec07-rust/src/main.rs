use regex::Regex;
use std::fs::File;
use std::io::{BufRead, BufReader};

#[derive(Debug, Clone)]
struct Directory {
    name: String,
    size: u32,
    is_file: bool,
}

#[derive(Debug)]
struct TreeNode<T> {
    parent: Option<usize>,
    children: Vec<Option<usize>>,
    data: T,
}

#[derive(Debug)]
struct TreeIndex<T> {
    nodes: Vec<TreeNode<T>>,
}

impl<T> TreeIndex<T> {
    fn new() -> TreeIndex<T> {
        TreeIndex { nodes: Vec::new() }
    }

    fn add_node(&mut self, parent: Option<usize>, data: T) -> Option<usize> {
        let node = TreeNode {
            parent: parent,
            children: Vec::new(),
            data,
        };
        self.nodes.push(node);
        let node_id = Some(self.nodes.len() - 1);

        //add the node to the parent's children
        if let Some(parent_id) = parent {
            self.nodes[parent_id].children.push(node_id);
        }

        return node_id;
    }

    fn get_node(&self, index: Option<usize>) -> Option<&TreeNode<T>> {
        match index {
            Some(i) => self.nodes.get(i),
            None => None,
        }
    }

    fn get_node_mut(&mut self, index: Option<usize>) -> Option<&mut TreeNode<T>> {
        match index {
            Some(i) => self.nodes.get_mut(i),
            None => None,
        }
    }
}

fn get_input() -> Vec<String> {
    let file = File::open("input-simple.txt").expect("no such file");
    let buf = BufReader::new(file);
    buf.lines()
        .map(|l| l.expect("Could not parse line"))
        .collect()
}

fn node_exists_by_id(tree: &TreeIndex<Directory>, node_id: Option<usize>) -> bool {
    return tree.get_node(node_id).is_some();
}

fn node_exists_by_name(tree: &TreeIndex<Directory>, name: String) -> bool {
    return tree.nodes.iter().any(|node| node.data.name == name);
}

fn hande_cd(
    tree: &mut TreeIndex<Directory>,
    cur_node_id: Option<usize>,
    line: &str,
) -> Option<usize> {
    let reg_cd = Regex::new(r#"\$ cd ([/.[:alnum:]]+)"#).unwrap();

    //get the directory name
    let cap = reg_cd.captures(line).unwrap();
    let mut dir_name = cap.get(1).unwrap().as_str().to_string();
    if dir_name.eq("/") {
        dir_name = "root".to_string();
    }

    //create a mutable copy of the current node id
    let mut cur_node_id = cur_node_id;

    //special case for ..
    if dir_name.eq("..") {
        if let Some(parent_id) = tree.get_node(cur_node_id).unwrap().parent {
            cur_node_id = Some(parent_id);
        }
        return cur_node_id;
    }

    //check if the directory exists
    let dir_exists = node_exists_by_name(tree, dir_name.clone());

    if !dir_exists {
        //if it doesn't exist, create it
        let dir = Directory {
            name: dir_name.clone(),
            size: 0,
            is_file: false,
        };
        cur_node_id = tree.add_node(cur_node_id, dir);
    } else {
        //otherwise, get the node id for the existing directory
        //get the node id
        let node_id = tree
            .nodes
            .iter()
            .position(|node| node.data.name == dir_name)
            .unwrap();
        cur_node_id = Some(node_id);
    }

    //return the node id
    return cur_node_id;
}

fn handle_ls(
    tree: &mut TreeIndex<Directory>,
    cur_node_id: Option<usize>,
    line: &str,
) -> Option<usize> {
    //do nothing
    return cur_node_id;
}

fn handle_dir(
    tree: &mut TreeIndex<Directory>,
    cur_node_id: Option<usize>,
    line: &str,
) -> Option<usize> {
    let reg_dir = Regex::new(r"dir ([[:alnum:]]+)").unwrap();

    //get the directory name
    let cap = reg_dir.captures(line).unwrap();
    let dir_name = cap.get(1).unwrap().as_str().to_string();

    //check if the directory exists
    let dir_exists = node_exists_by_name(tree, dir_name.clone());

    if !dir_exists {
        //if it doesn't exist, create it
        let dir = Directory {
            name: dir_name.clone(),
            size: 0,
            is_file: false,
        };
        tree.add_node(cur_node_id, dir);
        //propagate_size(tree, cur_node_id)
    }

    //return the node id
    return cur_node_id;
}

fn handle_file(
    tree: &mut TreeIndex<Directory>,
    cur_node_id: Option<usize>,
    line: &str,
) -> Option<usize> {
    let reg_file = Regex::new(r"(\d+) ([[:alnum:].]+)").unwrap();

    //get the file name and size
    let cap = reg_file.captures(line).unwrap();
    let file_name = cap.get(2).unwrap().as_str().to_string();
    let file_size = cap.get(1).unwrap().as_str().parse::<u32>().unwrap();

    //check if the file exists
    let file_exists = node_exists_by_name(tree, file_name.clone());

    if !file_exists {
        //if it doesn't exist, create it
        let file = Directory {
            name: file_name.clone(),
            size: file_size,
            is_file: true,
        };
        let new_node_id = tree.add_node(cur_node_id, file);
        propagate_size(tree, new_node_id);
    }

    //return the node id
    return cur_node_id;
}

fn apply_line(
    tree: &mut TreeIndex<Directory>,
    cur_node_id: Option<usize>,
    line: &str,
) -> Option<usize> {
    let reg_cd = Regex::new(r#"\$ cd ([/.[:alnum:]]+)"#).unwrap();
    let reg_ls = Regex::new(r"\$ ls").unwrap();
    let reg_dir = Regex::new(r"dir ([[:alnum:]]+)").unwrap();
    let reg_file = Regex::new(r"(\d+) ([[:alnum:].]+)").unwrap();

    let mut cur_node_id = cur_node_id;

    if reg_cd.is_match(line) {
        cur_node_id = hande_cd(tree, cur_node_id, line);
    } else if reg_ls.is_match(line) {
        cur_node_id = handle_ls(tree, cur_node_id, line);
    } else if reg_dir.is_match(line) {
        cur_node_id = handle_dir(tree, cur_node_id, line);
    } else if reg_file.is_match(line) {
        cur_node_id = handle_file(tree, cur_node_id, line);
    }

    return cur_node_id;
}

fn propagate_size(tree: &mut TreeIndex<Directory>, node_id: Option<usize>) {
    let size = tree.get_node_mut(node_id).unwrap().data.size;
    let mut cur_parent = tree.get_node(node_id).unwrap().parent;

    while cur_parent != None {
        tree.get_node_mut(cur_parent).unwrap().data.size += size;
        cur_parent = tree.get_node(cur_parent).unwrap().parent;
    }
}

fn get_full_path(tree: &TreeIndex<Directory>, node_id: Option<usize>) -> String {
    let mut cur_node_id = node_id;
    let mut path = String::new();

    while cur_node_id != None {
        let node = tree.get_node(cur_node_id).unwrap();
        path = node.data.name.clone() + "/" + &path;
        cur_node_id = node.parent;
    }

    return path;
}

fn recurse_tree_for_size(tree: &TreeIndex<Directory>, node_id: Option<usize>, cur_size) -> u32 {
	let mut size = 0;

	let node = tree.get_node(node_id).unwrap();

	for child_id in node.children.iter() {
		size += recurse_tree_for_size(tree, child_id.clone());
	}

	return size;
}

fn main() {
    //regexes
    let reg_cd = Regex::new(r#"\$ cd ([/.[:alnum:]]+)"#).unwrap();
    let reg_ls = Regex::new(r"\$ ls").unwrap();
    let reg_dir = Regex::new(r"\$ ls").unwrap();

    let lines = get_input();

    let mut tree = TreeIndex::<Directory>::new();

    let mut cur_node_id = None;

    for line in lines {
        cur_node_id = apply_line(&mut tree, cur_node_id, line.as_str());
    }

	let root_node = Some(0);
	let root_size = recurse_tree_for_size(&tree, root_node);

	println!("root size: {}", root_size);

    //println!("{:?}", tree);
    //println!("{:?}", cur_node_id);
}
