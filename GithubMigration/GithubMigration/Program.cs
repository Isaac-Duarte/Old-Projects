using System;
using System.IO;
using System.Collections.Generic;
using System.Threading.Tasks;

using GithubMigration.Models;

using LibGit2Sharp;

namespace GithubMigration
{
    class Program
    {
        public static int complete;
        public static List<Repo> Repos;

        static async Task Main()
        {
            API test = new API("Isaac-Duarte");

            Repos =  await test.GetRepoos();

            CreateDirectory("Repos");

            foreach (Repo repo in Repos)
            {
                Repository.Clone(repo.GitUrl, $"Repos/{repo.FullName}");
            }
        }

        public static void CreateDirectory(string directory)
        {
            if (!Directory.Exists(directory))
            {
                Directory.CreateDirectory(directory);
            }
        }
    }
}
