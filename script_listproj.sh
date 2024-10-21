#!/bin/bash
echo "Project,Folder,Owners,Last Log Date,Last Log Data"
for i in $(gcloud projects list --format="value(projectId)" | grep -v sys-)
do 
	PARENT=$(gcloud projects describe $i --format="value(parent.id)")
    	OWNERS=$(gcloud projects get-iam-policy $i --flatten="bindings[].members" --filter="bindings.role=roles/owner" --format="value(bindings.members)")	
	LASTLOG=$(gcloud logging read "" --project=$i --freshness=1y --limit=1 --format="value(protoPayload.methodName)")
	LOGLOGDATE=$(gcloud logging read "" --project=$i --freshness=1y --limit=1 --format="value(receiveTimestamp)")
	OWNER=$(echo "$OWNERS" | tr '\n' ' ')
echo "$i,$PARENT,$OWNER,$LASTLOGDATE,$LASTLOG"
done

#gcloud projects list --format="table(projectNumber,projectId,Name,createTime.date(tz=LOCAL),lifecycleState)" > gcp.txt
