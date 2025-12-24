namespace Scheduler.Api.Models;

public class Rank
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Code { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;
    public ICollection<ApplicationUser> Users { get; set; } = new List<ApplicationUser>();
}
