using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Scheduler.Api.Models;

namespace Scheduler.Api.Data;

public class SchedulerDbContext : IdentityDbContext<ApplicationUser>
{
    public SchedulerDbContext(DbContextOptions<SchedulerDbContext> options)
        : base(options)
    {
    }

    public DbSet<Rank> Ranks => Set<Rank>();
    public DbSet<Assignment> Assignments => Set<Assignment>();
    public DbSet<Grant> Grants => Set<Grant>();
    public DbSet<ShiftType> ShiftTypes => Set<ShiftType>();
    public DbSet<Schedule> Schedules => Set<Schedule>();
    public DbSet<ScheduleEntry> ScheduleEntries => Set<ScheduleEntry>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);

        builder.Entity<Rank>().HasIndex(rank => rank.Code).IsUnique();
        builder.Entity<Assignment>().HasIndex(assignment => assignment.Code).IsUnique();
        builder.Entity<Grant>().HasIndex(grant => grant.Code).IsUnique();

        builder.Entity<ScheduleEntry>()
            .HasOne(entry => entry.Assignment)
            .WithMany()
            .HasForeignKey(entry => entry.AssignmentId)
            .OnDelete(DeleteBehavior.SetNull);

        builder.Entity<ScheduleEntry>()
            .HasOne(entry => entry.Grant)
            .WithMany()
            .HasForeignKey(entry => entry.GrantId)
            .OnDelete(DeleteBehavior.SetNull);

        builder.Entity<ScheduleEntry>()
            .HasIndex(entry => new { entry.UserId, entry.StartTime });

        builder.Entity<ScheduleEntry>()
            .HasIndex(entry => new { entry.ScheduleId, entry.StartTime });
    }
}
