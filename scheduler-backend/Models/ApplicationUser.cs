using Microsoft.AspNetCore.Identity;

namespace Scheduler.Api.Models;

public class ApplicationUser : IdentityUser
{
    public Guid? RankId { get; set; }
    public Rank? Rank { get; set; }

    public Guid? AssignmentId { get; set; }
    public Assignment? Assignment { get; set; }

    public Guid? GrantId { get; set; }
    public Grant? Grant { get; set; }

    public ICollection<ScheduleEntry> ScheduleEntries { get; set; } = new List<ScheduleEntry>();
}
