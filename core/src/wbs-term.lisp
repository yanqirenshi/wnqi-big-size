(in-package :wnqi-big-size)

(defgeneric get-schedule (graph target)
  (:method (graph (target workpackage))
    (let ((ret (shinra:find-r-vertex graph 'edge :from target :vertex-class 'schedule :edge-type :have-to)))
      (when (< 1 (length ret))
        (warn "スケジュールが二件以上登録されています。 node=~a, schedule=~a" target ret))
      (car ret))))

(defun %tx-add-schedule (graph node start end)
  (when (get-schedule graph node)
    (error "すでにスケジュールが登録されています。 \nスケジュールを変更する場合はtx-change-schedule を利用してください。"))
  (tx-make-edge graph 'edge
                node
                (tx-make-vertex graph 'schedule `((start ,start) (end ,end)))
                :have-to))

(defgeneric tx-add-schedule (graph workpackage start end)
  (:method (graph (workpackage workpackage) (start local-time:timestamp) (end local-time:timestamp))
    (%tx-add-schedule graph workpackage start end)))
