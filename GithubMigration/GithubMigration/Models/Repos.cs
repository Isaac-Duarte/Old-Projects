using System;
using System.Collections.Generic;
using System.Text;

using Newtonsoft.Json;

namespace GithubMigration.Models
{
    class Repo
    {
        [JsonProperty("owner")]
        public Owner Owner { get; set; }

        [JsonProperty("license")]
        public License License { get; set; }

        [JsonProperty(PropertyName = "id")]
        public string ID { get; set; }

        [JsonProperty(PropertyName = "node_id")]
        public string NodeID { get; set; }

        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        [JsonProperty(PropertyName = "full_name")]
        public string FullName { get; set; }

        [JsonProperty(PropertyName = "private")]
        public string Private { get; set; }

        [JsonProperty(PropertyName = "html_url")]
        public string HtmlUrl { get; set; }

        [JsonProperty(PropertyName = "description")]
        public string Description { get; set; }

        [JsonProperty(PropertyName = "fork")]
        public string Fork { get; set; }

        [JsonProperty(PropertyName = "url")]
        public string Url { get; set; }

        [JsonProperty(PropertyName = "forks_url")]
        public string ForksUrl { get; set; }

        [JsonProperty(PropertyName = "keys_url")]
        public string KeysUrl { get; set; }

        [JsonProperty(PropertyName = "collaborators_url")]
        public string CollaboratorsUrl { get; set; }

        [JsonProperty(PropertyName = "teams_url")]
        public string TeamsUrl { get; set; }

        [JsonProperty(PropertyName = "hooks_url")]
        public string HooksUrl { get; set; }

        [JsonProperty(PropertyName = "issue_events_url")]
        public string IssueEventsUrl { get; set; }

        [JsonProperty(PropertyName = "events_url")]
        public string EventsUrl { get; set; }

        [JsonProperty(PropertyName = "assignees_url")]
        public string AssigneesUrl { get; set; }

        [JsonProperty(PropertyName = "branches_url")]
        public string BranchesUrl { get; set; }

        [JsonProperty(PropertyName = "tags_url")]
        public string TagsUrl { get; set; }

        [JsonProperty(PropertyName = "blobs_url")]
        public string BlobsUrl { get; set; }

        [JsonProperty(PropertyName = "git_tags_url")]
        public string GitTagsUrl { get; set; }

        [JsonProperty(PropertyName = "git_refs_url")]
        public string GitRefsUrl { get; set; }

        [JsonProperty(PropertyName = "trees_url")]
        public string TreesUrl { get; set; }

        [JsonProperty(PropertyName = "statuses_url")]
        public string StatusesUrl { get; set; }

        [JsonProperty(PropertyName = "languages_url")]
        public string LanguagesUrl { get; set; }

        [JsonProperty(PropertyName = "stargazers_url")]
        public string StargazersUrl { get; set; }

        [JsonProperty(PropertyName = "contributors_url")]
        public string ContributorsUrl { get; set; }

        [JsonProperty(PropertyName = "subscribers_url")]
        public string SubscribersUrl { get; set; }

        [JsonProperty(PropertyName = "subscription_url")]
        public string SubscriptionUrl { get; set; }

        [JsonProperty(PropertyName = "commits_url")]
        public string CommitsUrl { get; set; }

        [JsonProperty(PropertyName = "git_commits_url")]
        public string GitCommitsUrl { get; set; }

        [JsonProperty(PropertyName = "comments_url")]
        public string CommentsUrl { get; set; }

        [JsonProperty(PropertyName = "issue_comment_url")]
        public string IssueCommentUrl { get; set; }

        [JsonProperty(PropertyName = "contents_url")]
        public string ContentsUrl { get; set; }

        [JsonProperty(PropertyName = "compare_url")]
        public string CompareUrl { get; set; }

        [JsonProperty(PropertyName = "merges_url")]
        public string MergesUrl { get; set; }

        [JsonProperty(PropertyName = "archive_url")]
        public string ArchiveUrl { get; set; }

        [JsonProperty(PropertyName = "downloads_url")]
        public string DownloadsUrl { get; set; }

        [JsonProperty(PropertyName = "issues_url")]
        public string IssuesUrl { get; set; }

        [JsonProperty(PropertyName = "pulls_url")]
        public string PullsUrl { get; set; }

        [JsonProperty(PropertyName = "milestones_url")]
        public string MilestonesUrl { get; set; }

        [JsonProperty(PropertyName = "notifications_url")]
        public string NotificationsUrl { get; set; }

        [JsonProperty(PropertyName = "labels_url")]
        public string LabelsUrl { get; set; }

        [JsonProperty(PropertyName = "releases_url")]
        public string ReleasesUrl { get; set; }

        [JsonProperty(PropertyName = "deployments_url")]
        public string DeploymentsUrl { get; set; }

        [JsonProperty(PropertyName = "created_at")]
        public string CreatedAt { get; set; }

        [JsonProperty(PropertyName = "updated_at")]
        public string UpdatedAt { get; set; }

        [JsonProperty(PropertyName = "pushed_at")]
        public string PushedAt { get; set; }

        [JsonProperty(PropertyName = "git_url")]
        public string GitUrl { get; set; }

        [JsonProperty(PropertyName = "ssh_url")]
        public string SshUrl { get; set; }

        [JsonProperty(PropertyName = "clone_url")]
        public string CloneUrl { get; set; }

        [JsonProperty(PropertyName = "svn_url")]
        public string SvnUrl { get; set; }

        [JsonProperty(PropertyName = "homepage")]
        public string Homepage { get; set; }

        [JsonProperty(PropertyName = "size")]
        public string Size { get; set; }

        [JsonProperty(PropertyName = "stargazers_count")]
        public string StargazersCount { get; set; }

        [JsonProperty(PropertyName = "watchers_count")]
        public string WatchersCount { get; set; }

        [JsonProperty(PropertyName = "language")]
        public string Language { get; set; }

        [JsonProperty(PropertyName = "has_issues")]
        public string HasIssues { get; set; }

        [JsonProperty(PropertyName = "has_projects")]
        public string HasProjects { get; set; }

        [JsonProperty(PropertyName = "has_downloads")]
        public string HasDownloads { get; set; }

        [JsonProperty(PropertyName = "has_wiki")]
        public string HasWiki { get; set; }

        [JsonProperty(PropertyName = "has_pages")]
        public string HasPages { get; set; }

        [JsonProperty(PropertyName = "forks_count")]
        public string ForksCount { get; set; }

        [JsonProperty(PropertyName = "mirror_url")]
        public string MirrorUrl { get; set; }

        [JsonProperty(PropertyName = "archived")]
        public string Archived { get; set; }

        [JsonProperty(PropertyName = "disabled")]
        public string Disabled { get; set; }

        [JsonProperty(PropertyName = "open_issues_count")]
        public string OpenIssuesCount { get; set; }

        [JsonProperty(PropertyName = "forks")]
        public string Forks { get; set; }

        [JsonProperty(PropertyName = "open_issues")]
        public string OpenIssues { get; set; }

        [JsonProperty(PropertyName = "watchers")]
        public string Watchers { get; set; }

        [JsonProperty(PropertyName = "default_branch")]
        public string DefaultBranch { get; set; }
    }

    class Owner
    {
        [JsonProperty(PropertyName = "login")]
        public string Login { get; set; }

        [JsonProperty(PropertyName = "id")]
        public string ID { get; set; }

        [JsonProperty(PropertyName = "node_id")]
        public string BNodeID { get; set; }

        [JsonProperty(PropertyName = "avatar_url")]
        public string AvatarUrl { get; set; }

        [JsonProperty(PropertyName = "gravatar_id")]
        public string GravatarID { get; set; }

        [JsonProperty(PropertyName = "url")]
        public string Url { get; set; }

        [JsonProperty(PropertyName = "html_url")]
        public string HtmlUrl { get; set; }

        [JsonProperty(PropertyName = "followers_url")]
        public string FollowersUrl { get; set; }

        [JsonProperty(PropertyName = "following_url")]
        public string FollowingUrl { get; set; }

        [JsonProperty(PropertyName = "gists_url")]
        public string GistsUrl { get; set; }

        [JsonProperty(PropertyName = "starred_url")]
        public string StarredUrl { get; set; }

        [JsonProperty(PropertyName = "subscriptions_url")]
        public string SubscriptionsUrl { get; set; }

        [JsonProperty(PropertyName = "organizations_url")]
        public string OrganizationsUrl { get; set; }

        [JsonProperty(PropertyName = "repos_url")]
        public string ReposUrl { get; set; }

        [JsonProperty(PropertyName = "events_url")]
        public string EventsUrl { get; set; }

        [JsonProperty(PropertyName = "received_events_url")]
        public string ReceivedEventsUrl { get; set; }

        [JsonProperty(PropertyName = "type")]
        public string Type { get; set; }

        [JsonProperty(PropertyName = "site_admin")]
        public string SiteAdmin { get; set; }
    }

    class License
    {
        [JsonProperty(PropertyName = "key")]
        public string Key { get; set; }

        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        [JsonProperty(PropertyName = "spdx_id")]
        public string SpdxID { get; set; }

        [JsonProperty(PropertyName = "url")]
        public string Url { get; set; }

        [JsonProperty(PropertyName = "node_id")]
        public string NodeID { get; set; }
    }

}

