-- Get number of selections per organisations in sorter order
SELECT name, COUNT(*) selections
FROM
(
	SELECT organizations.* FROM organizations INNER JOIN projects ON organizations.id = projects.organization_id
)
GROUP BY name ORDER BY selections DESC


-- Get the maximum used tags
SELECT name, COUNT(*) as count FROM tags GROUP BY name ORDER BY count DESC
