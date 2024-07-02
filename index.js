import fs from "fs/promises";
import fsync from "fs";

// const rawPath = "./data/raw";
// const files = await fs.readdir(rawPath);

// files.forEach(async (file) => {
//     const num = await formatCheck(file, rawPath);
//     console.log(`File ${file} has ${num} errors`);
// });

// async function formatCheck(filename, path = ".") {
//     let errorCount = 0;
//     const split = "-&&&-";
//     const splitNums = 6;
//     const file = `${path}/${filename}`;
//     const data = (await fs.readFile(file, "utf-8")).split("\n");
//     for (let i = 0; i < data.length; i++) {
//         const notSplitRow = data[i];
//         const row = data[i].split(split);
//         if (row.length <= 0) {
//             console.log("Empty row");
//             continue;
//         }
//         if (row[0].startsWith("0-")) {
//             // console.log(`${notSplitRow}`);
//             continue;
//         }
//         if (!row.length == splitNums || !row.toString()) {
//             errorCount++;
//             console.error(`Error on line: ${i + 1} file ${filename}`);
//             console.error(`Row: ${notSplitRow}`);
//         }
//     }
//     return errorCount;
// }

// let p = "./data/xlsx/"
// let t = syncFs.readdirSync(p).filter((name) => name.endsWith(".xlsx"));

// t.forEach((name) => {
//     let split = name.split("-").map((x) => x.trim());
//     let join = split.slice(1,split.length).map(x=>x.split(" ").join("_")).join(" ");
//     syncFs.renameSync(p+name,p+join);
// });

// let t1 = syncFs
//     .readdirSync("./data/temp/raw")
//     .filter((name) => name.endsWith(".txt"))
//     .map((name) => name.split(".")[0]);
// let t = syncFs
//     .readdirSync("./data/temp/xlsx")
//     .filter((name) => name.endsWith(".xlsx"))
//     .map((name) => name.split(".")[0]);

// t.forEach((name) => {
//     if (t1.includes(name)) {
//         console.info(name);
//     } else {
//         console.error(name);
//     }
// });

// let p = "./data/temp/";
// let txts = syncFs.readdirSync(p + "raw/");
// txts.forEach((filename) => {
//     let name = filename.split(".")[0];
//     let newName = name.split(" ");
//     newName = newName.slice(0, 3).join(" ");
//     if (filename != newName + ".txt") {
//         fs.rename(p + "raw/" + filename, p + "raw/" + newName + ".txt")
//             .then(() => {
//                 console.info(`renamed ${filename} ==> ${newName}.txt`);
//             })
//             .catch((err) => {
//                 console.error(`cannot rename ${filename} ==> ${newName}.txt`);
//             });
//     }
//     if (syncFs.existsSync(p + "xlsx/" + newName + ".xlsx")) {
//         fs.unlink(p + "xlsx/" + newName + ".xlsx");
//         console.error(`unlinked ${newName}.xlsx`);
//     }
// });

// const questions = [];
// let p = "./data/raw/";
// let files = syncFs.readdirSync(p);
// async function readFiles() {
//     files.forEach(async (filename) => {
//         const filesplit = filename.split(" ");
//         if (filesplit[0] == "autovetture") {
//             let data = (await fs.readFile(p + filename, "utf-8")).split("\r\n");
//             let provincia = "NAN";
//             for (let i = 0; i < data.length; i++) {
//                 let row = data[i];
//                 let split = row.split("-&&&-");
//                 // if (!split || split[0].startsWith("0-")) {
//                 //     continue;
//                 // console.log(provincia);

//                 if (row.startsWith("0-")) {
//                     if (row.startsWith("0-PROVINCIA DI")) {
//                         provincia = "NAN";
//                     }
//                     if (row.startsWith("0-PROVINCIA DI FIRENZE")) {
//                         provincia = "FI";
//                     }
//                     continue;
//                 }
//                 if (split.length != 6) {
//                     console.error(
//                         `Error on line: ${i + 1} file ${filename}, row: ${row}`
//                     );
//                     continue;
//                 }
//                 const [num, question, A, B, C, correct] = split;
//                 if (filesplit[1] == "parte_tecnica" && provincia == "NAN") {
//                     continue;
//                 }
//                 questions.push({
//                     num,
//                     question,
//                     options: [A, B, C],
//                     correct,
//                     filename,
//                     provincia,
//                 });
//             }
//         }
//     });
// }

// await readFiles();
// await sleep(2000).then(() => {
//     fs.writeFile("./data/data.json", JSON.stringify(questions), "utf-8");
// });

// function sleep(ms) {
//     return new Promise((resolve) => setTimeout(resolve, ms));
// }

const path = "./data/raw/";
const filesnames = await fs.readdir(path);
let doneCount = 0;
const questions = [];

for (let i = 0; i < filesnames.length; i++) {
    readQuestionsFromFile(filesnames[i], path).then((qs) => {
        doneCount++;
        questions.push(...qs);
        if (doneCount >= filesnames.length) {
            const duplicateSignedQuestions = signDuplicateQuestions(questions);
            writeData(duplicateSignedQuestions, "all-data.json", "./data/");
            const duplicateFilteredQuestions = removeDuplicateSignedQuestions(
                duplicateSignedQuestions
            );
            writeData(duplicateFilteredQuestions, "data.json", "./data/");
        }
    });
}

async function readQuestionsFromFile(filename, path = "./") {
    const filenameSplit = filename.split(".")[0].split(" ");
    const forType = filenameSplit[0];
    const type = filenameSplit[1];
    const date = filenameSplit[2];
    const questions = [];
    let provincia = null;
    const data = (await fs.readFile(path + filename, "utf-8")).split("\r\n");
    for (let i = 0; i < data.length; i++) {
        const row = data[i];
        const columns = row.split("-&&&-");
        if (row.startsWith("0-PROVINCIA")) {
            provincia = row.split(" ").slice(2).join(" ");
            continue;
        }
        if (row.startsWith("0-")) {
            continue;
        }
        if (columns.length != 6) {
            console.error(`Error on line ${i + 1} in file ${filename}`);
            continue;
        }
        const line = i + 1;
        const [num, question, A, B, C, correct] = columns;
        questions.push({
            num,
            question,
            A,
            B,
            C,
            correct,
            provincia,
            forType,
            type,
            date,
            filename,
            line,
        });
    }
    return questions;
}

function writeData(data, filename, path) {
    fs.writeFile(path + filename, JSON.stringify(data))
        .then(() => {
            console.log(`${path}${filename} written`);
        })
        .catch(() => {
            console.log(`could've not write ${path}${filename}`);
        });
}

function signDuplicateQuestions(questions) {
    for (let i = 0; i < questions.length; i++) {
        for (let j = i + 1; j < questions.length; j++) {
            if (questions[i].question == questions[j].question) {
                questions[j].duplicate = true;
            }
        }
    }
    return questions;
}

function removeDuplicateSignedQuestions(questions) {
    questions = questions.filter((question) => {
        if (question.duplicate == true) {
            return false;
        }
        return true;
    });
    return questions;
}
